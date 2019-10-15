#!/bin/bash

set -euo pipefail

function ExportEnvironmentFile() {
  local VAR_PATH_FILE_ENV="${1}"
  if [ -f "${VAR_PATH_FILE_ENV}" ]; then
    while IFS='' read -r VAR_LINE || [[ -n "${VAR_LINE}" ]]; do
      if [ "${VAR_LINE}" = "" ]; then
        continue;
      fi
      if [[ ${VAR_LINE} != \#* ]]; then
        export "${VAR_LINE}"
      fi
    done < "${VAR_PATH_FILE_ENV}"
  else
    echo "Environment file '${VAR_PATH_FILE_ENV}' not found."
    exit 1
  fi
}

echo -e "Testing nginx configuration ..."

nginx -t

echo -e "Testing nginx configuration ... \033[0;32mdone\033[0m"

ExportEnvironmentFile "/etc/nginx/env/${1}"

mkdir -p "/etc/letsencrypt/san"

for VAR_VHOST_NAME in ${ENV_SERVICES_SERVER_NGINX_CERTBOT_VHOSTS}
do
  VAR_DOMAIN_ENV_NAME="ENV_SERVICES_SERVER_NGINX_CERTBOT_VHOST_${VAR_VHOST_NAME}_DOMAIN"
  VAR_UPSTREAM_ENV_NAME="ENV_SERVICES_SERVER_NGINX_CERTBOT_VHOST_${VAR_VHOST_NAME}_UPSTREAM"
  VAR_EMAIL_ENV_NAME="ENV_SERVICES_SERVER_NGINX_CERTBOT_VHOST_${VAR_VHOST_NAME}_EMAIL"
  VAR_STAGING_ENV_NAME="ENV_SERVICES_SERVER_NGINX_CERTBOT_VHOST_${VAR_VHOST_NAME}_STAGING"
  
  VAR_DOMAIN=${!VAR_DOMAIN_ENV_NAME}
  VAR_UPSTREAM=${!VAR_UPSTREAM_ENV_NAME}
  VAR_EMAIL=${!VAR_EMAIL_ENV_NAME}
  VAR_STAGING=${!VAR_STAGING_ENV_NAME}
  VAR_RENEW="keep"

  # request certificates
  CONST_DAYS_CERTIFICATE_VALIDITY=60
  VAR_DATE_NOW=$(date '+%s')
  VAR_DATE_RECREATION=$((VAR_DATE_NOW - $((24 * 60 * 60 * ${CONST_DAYS_CERTIFICATE_VALIDITY}))))
  VAR_PATH_FILE_SAN="/etc/letsencrypt/san/${VAR_DOMAIN}"

  if [ "${VAR_STAGING}" = "self-signed" ]; then
    VAR_STAGING_URL=""
  elif [ "${VAR_STAGING}" = "none" ]; then
    VAR_STAGING_URL="--server https://acme-v02.api.letsencrypt.org/directory"
  elif [ "${VAR_STAGING}" = "staging" ]; then
    VAR_STAGING_URL="--server https://acme-staging-v02.api.letsencrypt.org/directory"
  fi

  if [ ! -f "${VAR_PATH_FILE_SAN}" ]; then
    echo "No prior lets encrypt staging configuration found for '${VAR_DOMAIN}', seems to be new."
    VAR_RENEW="new"
  elif [ "$(cat ${VAR_PATH_FILE_SAN})" != "${VAR_STAGING}" ]; then
    echo "Found prior lets encrypt staging configuration for '${VAR_DOMAIN}'."
    echo " -> lets encrypt staging configuration changed from '$(cat ${VAR_PATH_FILE_SAN})' to '${VAR_STAGING}': certificate renewal required."
    VAR_RENEW="renew"
  elif (( $(date -r ${VAR_PATH_FILE_SAN} '+%s') < ${VAR_DATE_RECREATION})); then
    echo "Found prior lets encrypt staging configuration for '${VAR_DOMAIN}'."
    echo "  -> prior lets encrypt staging configuration is older than ${CONST_DAYS_CERTIFICATE_VALIDITY} days: certificate renewal required."
    VAR_RENEW="update"
  fi

  if [ "${VAR_RENEW}" != "keep" ]; then
    echo "Prepare certificate renewal for '${VAR_DOMAIN}': action '${VAR_RENEW}'."
    if [ "${VAR_RENEW}" == "renew" ]; then
      echo "  -> cleaning up certificate storage."
      certbot delete --cert-name "${VAR_DOMAIN}"
    fi
    /bin/bash /opt/server--nginx-certbot/request-certificate.sh \
              "${VAR_STAGING}"                                  \
              "${VAR_STAGING_URL}"                              \
              "${VAR_EMAIL}"                                    \
              "${VAR_DOMAIN}"
                
    # update san information
    echo "${VAR_STAGING}" > "${VAR_PATH_FILE_SAN}"
  fi

  # render configurations
  VAR_PATH_FILE_VHOST_SOURCE_TEMPLATE="/templates/vhost.template.conf"
  VAR_PATH_FILE_VHOST_SOURCE_MANUAL="/manual-config/${VAR_DOMAIN}.conf"

  if [ -f "${VAR_PATH_FILE_VHOST_SOURCE_MANUAL}" ]; then
    VAR_PATH_FILE_VHOST_SOURCE="${VAR_PATH_FILE_VHOST_SOURCE_MANUAL}"
  else
    VAR_PATH_FILE_VHOST_SOURCE="${VAR_PATH_FILE_VHOST_SOURCE_TEMPLATE}"
  fi

  VAR_PATH_FILE_VHOST_TARGET="/etc/nginx/vhosts/$(basename ${VAR_DOMAIN}).conf"
  VAR_PATH_FILE_VHOST_TARGET_BACKUP="${VAR_PATH_FILE_VHOST_TARGET}.bak"

  if [ -f "${VAR_PATH_FILE_VHOST_TARGET}" ]; then
    cp -f "${VAR_PATH_FILE_VHOST_TARGET}" "${VAR_PATH_FILE_VHOST_TARGET_BACKUP}"
  fi

  echo "Rendering vhost configuration for '${VAR_DOMAIN}' from '${VAR_PATH_FILE_VHOST_SOURCE}'."
  
  sed -e "s/\${DOMAIN}/${VAR_DOMAIN}/g" \
      -e "s/\${UPSTREAM}/${VAR_UPSTREAM}/" \
      -e "s/\${PATH}/${VAR_DOMAIN}/" \
      "${VAR_PATH_FILE_VHOST_SOURCE}" > "${VAR_PATH_FILE_VHOST_TARGET}"

  VAR_IS_CONFIGURATION_VALID=$(/bin/bash /opt/server--nginx-certbot/test-nginx-configuration.sh)

  if [ "${VAR_IS_CONFIGURATION_VALID}" != "true" ]; then
    echo "Vhost configuration for '${VAR_DOMAIN}' is invalid."
    rm -f "${VAR_PATH_FILE_VHOST_TARGET}"
    if [ -f "${VAR_PATH_FILE_VHOST_TARGET_BACKUP}" ]; then
      echo "Restoring prior configuration."
      mv "${VAR_PATH_FILE_VHOST_TARGET_BACKUP}" "${VAR_PATH_FILE_VHOST_TARGET}"
    fi
  fi
  
  rm -f "${VAR_PATH_FILE_VHOST_TARGET_BACKUP}"
done

echo -e "Reloading nginx ..."

nginx -s reload

echo -e "Reloading nginx ... \033[0;32mdone\033[0m"