#!/bin/bash

set -euo pipefail

source bash/util/functions.bash

PROJECT_DIR=$( realpath . )

function run() {
    local CONFIGURATION=${1}
    local DOCKER_CONFIG_DIR=docker/${CONFIGURATION}

    export_environment_for_configuration ${CONFIGURATION}

    print_title \
    "Creating and starting containers and networks"

    cd \
    ${DOCKER_CONFIG_DIR}

    docker-compose --file default.docker-compose \
                   up --build --detach

    cd \
    ${PROJECT_DIR}

    print_title_done \
    "Creating and starting containers and networks"
}

run ${@}
