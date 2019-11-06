#!/bin/bash

function __done() {
    echo "\033[0;32mdone\033[0m"
}

function print_title() {
    echo -e "${1} ..."
}

function print_title_done() {
    echo -e "${1} ... $( __done )"
}
