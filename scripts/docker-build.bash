#!/usr/bin/env bash

# shellcheck source=assets/variables
source assets/variables

DOCKER_BUILDKIT=1 docker build \
    --build-arg UPSTREAM_BRANCH="$UPSTREAM_BRANCH" \
    --build-arg UPSTREAM_REPO="$UPSTREAM_REPO" \
    --build-arg USR="$USR" \
    --build-arg USR_HOME="$USR_HOME" \
    --progress plain \
    .
