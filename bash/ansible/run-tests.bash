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
    local CACHE_DIR=cache
    local SHOULD_PRUNE=
    set +u
    [[ "${1}" = "prune-between-tests" ]] && SHOULD_PRUNE=1 || SHOULD_PRUNE=0
    set -u

    mkdir --parents \
    ${CACHE_DIR}
    rm --force \
    ${CACHE_DIR}/*

    for TEST in ${TESTS[@]}
    do
        set +e
        /bin/bash bash/ansible/run-test.bash \
        ${TEST}
        local TEST_RC=${?}
        set -e

        if [ ${TEST_RC} != 0 ];
        then
            touch ${CACHE_DIR}/${TEST}.fail
        fi

        prune \
        ${SHOULD_PRUNE}
    done

    local HAS_ANY_TEST_FAILED="false"

    print_title \
    "Printing summary"
    for TEST in ${TESTS[@]}
    do
        if [ -f ${CACHE_DIR}/${TEST}.fail ];
        then
            HAS_ANY_TEST_FAILED="true"
            print_h1_error \
            "Test '${TEST}'"
        else
            print_h1_done \
            "Test '${TEST}'"
        fi
    done
    print_title_done \
    "Printing summary"

    rm --force \
    ${CACHE_DIR}/*

    if [ "${HAS_ANY_TEST_FAILED}" = "true" ];
    then
        exit 1
    fi
}

run ${@}
