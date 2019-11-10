#!/bin/bash

set -euo pipefail

source /docker/util/cascade.bash

PID_OF_SLEEP=

function handle_termination_signal() {
    kill -KILL \
    ${PID_OF_SLEEP}
}

function wait_for_termination() {
    /bin/bash /docker/util/sleep-forever.bash & \
    PID_OF_SLEEP=${!}
    wait \
    ${PID_OF_SLEEP}
}

trap handle_termination_signal SIGTERM

run_cascade "entry"

wait_for_termination
