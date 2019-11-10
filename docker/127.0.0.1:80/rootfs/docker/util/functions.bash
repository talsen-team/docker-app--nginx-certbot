#!/bin/bash

function ensure_existing_file() {
    local PATH_TO_FILE=${1}
    local MESSAGE_PREFIX=${2}

    if [ ! -f ${PATH_TO_FILE} ];
    then
        print_error "${2}file was not found (expected at '${PATH_TO_FILE}')"
        exit 1
    fi
}

function print_date_now() {
    echo $( date +%Y-%m-%d--%H-%M-%S )
}

function print_error() {
    echo -e "$( print_date_now ) Error:   ${1} ..."
}

function print_info() {
    echo -e "$( print_date_now ) Info:    ${1} ..."
}

function print_success() {
    echo -e "$( print_date_now ) Success: ${1} ..."
}

function print_warning() {
    echo -e "$( print_date_now ) Warning: ${1} ..."
}
