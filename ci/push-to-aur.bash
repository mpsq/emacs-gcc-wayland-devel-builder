#!/usr/bin/env bash

set -euxo pipefail
shopt -s expand_aliases

cd /home/pcr

# Checksum artifacts
sum=$(sha512sum "$PKG_VERSION".tar.gz | sed -r 's/(.*)\s\s.*/\1/')

# Setup SSH
mkdir .ssh
echo "$PUB_KEY" | tr -d '\r' > .ssh/id_aur.pub
echo "$PRIV_KEY" | base64 --decode > .ssh/id_aur
chmod 600 .ssh/id_aur
echo -en 'Host aur.archlinux.org\n  IdentityFile /home/pcr/.ssh/id_aur\n  User aur\n' > .ssh/config
ssh-keyscan aur.archlinux.org > .ssh/known_hosts
ssh-keyscan 95.216.144.15 >> .ssh/known_hosts

# Setup git
alias mygit="git -c user.name=Méril\ Pilon -c user.email=me@mpsq.org"
mygit clone ssh://aur.archlinux.org/emacs-gcc-wayland-devel-bin.git
cd emacs-gcc-wayland-devel-bin

# Amend package, set pkgver, sha512 sum and pkgrel + fix permissions
sed -i -r -e 's~pkgver=.*~pkgver='$PKG_VERSION'~' PKGBUILD
sed -i -r -e 's~sha512sums=.*~sha512sums=\("'"$sum"'"\)~' PKGBUILD
sed -i -r -e 's/pkgrel=.*/pkgrel=1/' PKGBUILD
rm .SRCINFO
su pcr -c "makepkg --printsrcinfo > .SRCINFO"

# Push changes
mygit add .SRCINFO PKGBUILD
mygit commit -m "Bump to $PKG_VERSION"
mygit push origin master
