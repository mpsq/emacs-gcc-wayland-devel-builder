#!/usr/bin/env bash

set -euxo pipefail

PKG_VERSION=$(
  curl -s "$UPSTREAM_SRC"/configure.ac | \
    grep AC_INIT | \
    sed -e 's/^.\+\ \([0-9]\+\.[0-9]\+\.[0-9]\+\?\).\+$/\1/'
)
PKG_VERSION+="."
PKG_VERSION+="$NEW_COMMIT_N"

export PKG_VERSION="${PKG_VERSION}"

echo "::set-output name=pkg_version::${PKG_VERSION}"
