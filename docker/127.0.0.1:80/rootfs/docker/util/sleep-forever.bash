#!/bin/bash

set -euo pipefail

function sleep_forever() {
    while true;
    do
        sleep 10000
    done
}

sleep_forever
