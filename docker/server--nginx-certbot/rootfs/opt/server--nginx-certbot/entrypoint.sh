#!/bin/bash

set -euo pipefail

VAR_PID_NGINX=0

function generate_dh_params() {
    echo -e "Generating DH params ..."

    if [ ! -f "/cache/dhparams.pem" ]; then
        openssl dhparam -out "/cache/dhparams.pem" 2048
    fi
    ln -fs "/cache/dhparams.pem" "/etc/ssl/dhparams.pem"

    echo -e "Generating DH params ... \033[0;32mdone\033[0m"
}

function start_nginx() {
    echo -e "Starting nginx ..."

    /usr/sbin/nginx -g "daemon off;" & \
    VAR_PID_NGINX=${!}

    echo -e "Starting nginx ... \033[0;32mdone\033[0m"
}

function stop_nginx() {
    echo -e "Stopping nginx ..."

    kill -TERM ${VAR_PID_NGINX}

    echo -e "Stopping nginx ... \033[0;32mdone\033[0m"
}

function handle_termination_signal() {
    stop_nginx
    exit 0
}

generate_dh_params
start_nginx

trap handle_termination_signal SIGTERM

wait ${VAR_PID_NGINX}
