#!/usr/bin/env bash

set -euxo pipefail

cd /home/pcr

# Get sources
cp /__w/emacs-gcc-wayland-devel-builder/emacs-gcc-wayland-devel-builder/pull.bash pull.bash
cp /__w/emacs-gcc-wayland-devel-builder/emacs-gcc-wayland-devel-builder/PKGBUILD PKGBUILD
./pull.bash
chown -R pcr:pcr emacs

# Create artifacts
su pcr -c "makepkg"

# Unpack artifacts
mkdir out
tar xf emacs-1-1-x86_64.pkg.tar.zst -C out
rm emacs-1-1-x86_64.pkg.tar.zst
rm out/.BUILDINFO out/.MTREE out/.PKGINFO
tar czf "$PKG_VERSION".tar.gz -C out .

# Get release body
delta=$(echo "$NEW_COMMIT_N - $OLD_COMMIT_N" | bc)
echo -en "# Commits since last release\n\n" > body.md
echo -en "Check [upstream]("$UPSTREAM_REPO"/commits) for the full history.\n\n" >> body.md

# Get the list of commits since last release
curl -s "$UPSTREAM_API"/commits?per_page="$delta" | \
  # Parse and retain only the commit message + its url
  jq -r '.[] | (.commit.message | capture("(?<id>.+)\n").id) + " [commit](" + .html_url + ")"' | \
  # Remove "Merge" commits
  sed '/^Merge/,+1 d' | \
  # Remove any special char at the beginning of the message
  sed 's/^[^[:alnum:]]*//' | \
  # Prepend "- " to the message
  sed -r 's/(.*)/- \1/' >> body.md
