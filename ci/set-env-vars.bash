#!/usr/bin/env bash

set -euxo pipefail

VER=$(curl -s https://raw.githubusercontent.com/flatwhatson/emacs/pgtk-nativecomp/configure.ac | grep AC_INIT | sed -e 's/^.\+\ \([0-9]\+\.[0-9]\+\.[0-9]\+\?\).\+$/\1/')
VER+="."
VER+="$NEW_COMMIT_N"

export VER="${VER}"

echo "::set-output name=ver::${VER}"
