#!/bin/bash

set -euo pipefail

source bash/util/functions.bash

function run_test() {
    local TEST_NAME=${1}

    export ROLE_NAME=test--${TEST_NAME}.role
    export PROJECT_DIR=$( realpath . )
    export ANSIBLE_COMMON_DIR=${PROJECT_DIR}/ansible/common
    export TESTS_DIR=${PROJECT_DIR}/tests

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
