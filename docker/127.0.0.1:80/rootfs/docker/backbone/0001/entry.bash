#!/bin/bash

set -euo pipefail

source /docker/util/functions.bash

mkdir --parents      \
      /var/log/nginx

touch /var/log/nginx/{access,error}.log

nginx

print_info "Started NGINX"
