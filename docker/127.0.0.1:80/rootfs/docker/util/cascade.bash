#!/bin/bash

set -euo pipefail

source /docker/util/functions.bash

function run_cascade() {
    local NAME_OF_CASCADE=${1}

    local PATH_TO_SCRIPTS=/docker/backbone
    local PATH_TO_LOG_DIR=/var/log/backbone/${NAME_OF_CASCADE}
    local PATH_TO_LOF_FILE=${PATH_TO_LOG_DIR}/${NAME_OF_CASCADE}.log

    mkdir --parents ${PATH_TO_LOG_DIR}

    for SCRIPT in $( find ${PATH_TO_SCRIPTS} -name ${NAME_OF_CASCADE}.bash -type f -print | sort )
    do
        /bin/bash ${SCRIPT} >> ${PATH_TO_LOF_FILE} 2>&1
    done

    print_success "${NAME_OF_CASCADE^} cascade succeeded" >> ${PATH_TO_LOF_FILE} 2>&1
}
