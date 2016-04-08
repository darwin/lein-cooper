#!/usr/bin/env bash

set -e

# http://stackoverflow.com/a/26966800/84283
kill_descendant_processes() {
    local pid="$1"
    local and_self="${2:-false}"
    if children="$(pgrep -P "$pid")"; then
        for child in $children; do
            kill_descendant_processes "$child" true
        done
    fi
    if [[ "$and_self" == true ]]; then
        kill -9 "$pid"
    fi
}

trap "kill_descendant_processes $$; trap - EXIT; exit 0" EXIT

export COOPER_SPAWN=1

lein "$@"