#!/usr/bin/env bash

export SOURCE_DIR
SOURCE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SOURCE_DIR" || exit

export TF_VAR_environment_name
TF_VAR_environment_name="${PWD##*/}"

export TF_VAR_environment_owner
TF_VAR_environment_owner="$(whoami)"

export DOCKER_TAG
DOCKER_TAG="$TF_VAR_environment_name:latest"

docker_run() {
  local entrypoint="$1"
  shift

  docker run -it --rm \
    --entrypoint "$entrypoint" \
    -v "${SOURCE_DIR}:/root/workdir" \
    -v "${HOME}/.aws:/root/.aws" \
    -v "${HOME}/.gnupg:/root/.gnupg" \
    -e AWS_PROFILE \
    -e AWS_REGION \
    -e AWS_DEFAULT_REGION \
    -e AWS_ACCESS_KEY_ID \
    -e AWS_SECRET_ACCESS_KEY \
    -e AWS_SESSION_TOKEN \
    -e TF_VAR_environment_name \
    -e TF_VAR_environment_owner \
    "${DOCKER_TAG}" "$@"
}

docker_build() {
  docker build \
    -f "${SOURCE_DIR}/docker/Dockerfile" \
    -t "${DOCKER_TAG}" .
}
