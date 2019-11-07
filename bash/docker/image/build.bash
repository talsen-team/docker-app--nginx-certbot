#!/bin/bash

set -euo pipefail

source bash/util/functions.bash

PROJECT_DIR=$( realpath . )

function export_env_docker_images() {
    local PATH_TO_ENV_FILE=env/${1}/docker-images.env

    while IFS='' read -r LINE || [[ -n ${LINE} ]];
    do
        export ${LINE}
    done < ${PATH_TO_ENV_FILE}
}

function run() {
    local CONFIGURATION=${1}
    local DOCKER_CONFIG_DIR=docker/${CONFIGURATION}

    export_env_docker_images ${CONFIGURATION}

    print_title      "Building docker images"

    cd ${DOCKER_CONFIG_DIR}

    docker-compose --file default.docker-compose \
                   build

    cd ${PROJECT_DIR}

    print_title_done "Building docker images"
}

run ${@}
