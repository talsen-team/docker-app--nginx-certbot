#!/bin/bash

set -euo pipefail

source bash/util/functions.bash

function run() {
    local CONFIGURATION=${1}
    local DOCKER_CONFIG_DIR=docker/${CONFIGURATION}

    export_environment_for_configuration ${CONFIGURATION}

    print_title \
    "Building docker images"

    cd \
    ${DOCKER_CONFIG_DIR}

    docker-compose --file default.docker-compose \
                   build

    cd \
    ${PROJECT_DIR}

    print_title_done \
    "Building docker images"
}

run ${@}
