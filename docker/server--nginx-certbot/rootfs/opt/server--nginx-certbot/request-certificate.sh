#!/bin/bash

set -euo pipefail

VAR_STAGING=${1}
VAR_STAGING_URL=${2}
VAR_EMAIL=${3}
VAR_DOMAIN=${4}

if [ "${VAR_STAGING}" = "self-signed" ]; then
    /bin/bash /opt/server--nginx-certbot/request-certificate-self-signed.sh \
             "${VAR_STAGING_URL}"                                           \
             "${VAR_EMAIL}"                                                 \
             "${VAR_DOMAIN}"
else
    /bin/bash /opt/server--nginx-certbot/request-certificate-certbot.sh \
             "${VAR_STAGING_URL}"                                       \
             "${VAR_EMAIL}"                                             \
             "${VAR_DOMAIN}"
fi
