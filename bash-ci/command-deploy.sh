#!/bin/bash

set -euo pipefail

echo -e "Performing deployment ..."

/bin/bash bash-commands/docker-compose--compose--up.sh                    "." "default.docker-compose"
/bin/bash bash-commands--specific/administration--update-configuration.sh "." "default.docker-compose" "reverse-proxy.env"

echo -e "Performing deployment ... \033[0;32mdone\033[0m"
