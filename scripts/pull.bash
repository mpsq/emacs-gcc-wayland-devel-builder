#!/usr/bin/env bash

set -euxo pipefail

if [[ -d "emacs" ]]; then
  cd emacs
  git clean -fX
  git checkout .
  git pull --rebase origin "$UPSTREAM_BRANCH"
else
  git clone --depth=1 "$UPSTREAM_REPO"
  cd emacs
fi
