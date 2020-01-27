#!/bin/bash

set -euo pipefail

source bash-util/functions.sh

/bin/bash bash-ci/command-pull-images.sh

function wait_for_dh_params_creation() {
    echo " * Waiting for dh params creation ..."

    while [ ! -f "volumes/server--nginx-certbot/cache/dhparams.pem" ] || [ "$( cat volumes/server--nginx-certbot/cache/dhparams.pem )" = "" ];
    do
        echo " > Waiting ..."
        sleep 1
    done

    echo -e " * Waiting for dh params creation ... $( __done )"

    sleep 1
}

function deploy_service() {
    if [ ! -f "volumes/server--nginx-certbot/cache/dhparams.pem" ];
    then
        /bin/bash bash-commands/docker-compose--compose--up.sh                "." "default.docker-compose"
        wait_for_dh_params_creation
        /bin/bash bash-commands/docker-compose--compose--down.sh              "." "default.docker-compose"
    fi

    /bin/bash bash-commands/docker-compose--compose--up.sh                    "." "default.docker-compose"
    /bin/bash bash-commands--specific/administration--update-configuration.sh "." "default.docker-compose" "reverse-proxy.env"
}

echo -e "Performing deployment ..."

deploy_service

echo -e "Performing deployment ... \033[0;32mdone\033[0m"
