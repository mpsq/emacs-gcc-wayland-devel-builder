#!/usr/bin/env bash

set -euxo pipefail

status_code=$(curl -s -o "/dev/null" -w "%{http_code}" "https://api.github.com/repos/mpsq/emacs-gcc-wayland-devel-builder/releases/tags/$NEW_COMMIT_N-$PKG_REL")

if [[ "$status_code" == "200" ]]; then
  exit 1
fi