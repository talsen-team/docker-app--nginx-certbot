#!/bin/bash

set -euo pipefail

source bash/util/functions.bash

function prune() {
    local SHOULD_PRUNE=${1}

    print_title \
    "Pruning docker system"

    if [ ${SHOULD_PRUNE} = 1 ];
    then
        docker system prune --all --force
        print_title_done \
        "Pruning docker system"
    else
        print_title_skipped \
        "Pruning docker system"
    fi
}

function run() {
    local TESTS=( \
                  docker--compose--up \
                  docker--image--build \
                )
    local SHOULD_PRUNE=
    set +u
    [[ "${1}" = "prune-between-tests" ]] && SHOULD_PRUNE=1 || SHOULD_PRUNE=0
    set -u

    for TEST in ${TESTS[@]}
    do
        /bin/bash bash/ansible/run-test.bash \
        ${TEST}

        prune \
        ${SHOULD_PRUNE}
    done
}

run ${@}
