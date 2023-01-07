#!/usr/bin/env bash

set -euxo pipefail

# We set PKG_VERSION to "xx.xx.xx"
PKG_VERSION=$(
  curl -s "$UPSTREAM_SRC"/configure.ac |
    grep AC_INIT |
    sed -e 's/^.\+\ \([0-9]\+\.[0-9]\+\.[0-9]\+\?\).\+$/\1/'
)
PKG_VERSION+="."
# We concatenate the version number with commit count: xx.xx.xx.xxxxxx
PKG_VERSION+="$NEW_COMMIT_N"

# Export to env var + github action var
export PKG_VERSION="${PKG_VERSION}"
echo "pkg_version=$PKG_VERSION" >> $GITHUB_OUTPUT

pkgrel="1"
if [[ -v I_PKG_REL ]]; then
  pkgrel="$I_PKG_REL"
fi
export PKG_REL="${pkgrel}"
echo "pkg_rel=$pkgrel" >> $GITHUB_OUTPUT