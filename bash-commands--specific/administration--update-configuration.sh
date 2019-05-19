#!/bin/bash

set -euo pipefail

source bash-util/functions.sh

prepare_local_environment ${@}

VAR_NAME_OF_SERVICE="${3}"
VAR_NAME_OF_CONFIGURATION="${4}"

echo -E "Updating NGINX configuration '${VAR_NAME_OF_CONFIGURATION}' ..."

docker exec --tty                  \
            ${VAR_NAME_OF_SERVICE} \
                    /bin/bash /opt/server-nginx-certbot/command-update-configuration.sh "${VAR_NAME_OF_CONFIGURATION}"

echo -e "Updating NGINX configuration '${VAR_NAME_OF_CONFIGURATION}' ... $( __done )"
