#!/bin/bash

set -euo pipefail

VAR_STAGING_URL=${1}
VAR_EMAIL=${2}
VAR_DOMAIN=${3}

/bin/bash -c "certbot certonly                                                          \
                      --standalone --preferred-challenges http --text --non-interactive \
                      ${VAR_STAGING_URL}                                                \
                      --email ${VAR_EMAIL} --agree-tos                                  \
                      -d ${VAR_DOMAIN}                                                  \
                      --expand"
