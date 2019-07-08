#!/bin/bash

set -euo pipefail

VAR_STAGING_URL=${1}
VAR_EMAIL=${2}
VAR_DOMAIN=${3}

if [ -d /etc/letsencrypt/live/${VAR_DOMAIN} ]; then
    exit 0
fi

mkdir -p /etc/letsencrypt/live/${VAR_DOMAIN}/

openssl req -x509 -nodes -days 365                                                   \
        -newkey rsa:2048                                                             \
        -keyout /etc/letsencrypt/live/${VAR_DOMAIN}/privkey.pem                      \
        -out    /etc/letsencrypt/live/${VAR_DOMAIN}/fullchain.pem                    \
        -subj "/C=AT/ST=somewhere/L=somewhere/O=localhost/OU=localhost/CN=localhost"
