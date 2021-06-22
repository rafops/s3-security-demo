#!/usr/bin/env bash

SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# shellcheck source=./docker.sh
source "$SCRIPTDIR/docker.sh"

(
    cd "$SCRIPTDIR" || exit
    docker_run zsh
)
