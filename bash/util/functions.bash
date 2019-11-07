#!/bin/bash

function export_environment_for_configuration() {
    local CONFIGURATION=${1}

    print_title \
    "Prepare local environment for '${CONFIGURATION}'"

    export PROJECT_DIR=$( realpath . )
    export VOLUMES_DIR=${PROJECT_DIR}/volumes

    for FILE in $( find env/${CONFIGURATION} -name *.env -type f -print | sort )
    do
        while IFS='' read -r LINE || [[ -n ${LINE} ]];
        do
            export ${LINE}
        done < ${FILE}
    done

    print_title_done \
    "Prepare local environment for '${CONFIGURATION}'"
}

function __done() {
    echo "\033[0;32mdone\033[0m"
}

function __error() {
    echo "\033[0;31merror\033[0m"
}

function __skipped() {
    echo "\033[0;33mskipped\033[0m"
}

function print_h1_done() {
    echo -e " * ${1} ... $( __done )"
}

function print_h1_error() {
    echo -e " * ${1} ... $( __error )"
}

function print_title() {
    echo -e "${1} ..."
}

function print_title_done() {
    echo -e "${1} ... $( __done )"
}

function print_title_skipped() {
    echo -e "${1} ... $( __skipped )"
}
