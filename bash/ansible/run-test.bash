#!/bin/bash

set -euo pipefail

source bash/util/functions.bash

function run_test() {
    local TEST_NAME=${1}

    local ROLE_NAME=test--${TEST_NAME}.role
    local PROJECT_DIR=$( realpath . )
    local TESTS_DIR=${PROJECT_DIR}/tests

    export ROLE_NAME

    print_title \
    "Running test '${TEST_NAME}'"

    cd \
    ansible/${ROLE_NAME}

    molecule \
    test

    cd \
    ${PROJECT_DIR}

    print_title_done \
    "Running test '${TEST_NAME}'"
}

run_test ${@}
