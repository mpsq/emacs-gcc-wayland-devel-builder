#!/usr/bin/env bash

set -euxo pipefail
# Needed for "mygit" alias
shopt -s expand_aliases

# Checksum artifacts
cd "$HOME"
sum=$(sha512sum "$PKG_VERSION".tar.gz | sed -r 's/(.*)\s\s.*/\1/')

# Setup SSH
cd /root
mkdir .ssh
echo "$PUB_KEY" | tr -d '\r' > .ssh/id_aur.pub
echo "$PRIV_KEY" | base64 --decode > .ssh/id_aur
chmod 600 .ssh/id_aur
echo -en 'Host '"$AUR_DNS"'\n  IdentityFile /root/.ssh/id_aur\n  User aur\n' > .ssh/config
ssh-keyscan "$AUR_DNS" > .ssh/known_hosts
ssh-keyscan "$AUR_IP" >> .ssh/known_hosts

# Setup git
alias mygit="git -c user.name=Méril\ Pilon -c user.email=me@mpsq.org"
mygit clone ssh://"$AUR_DNS"/"$AUR_PKG".git
mv "$AUR_PKG" "$HOME"
chown -R pcr:pcr "$HOME"/"$AUR_PKG"
cd "$HOME"/"$AUR_PKG"

# Amend package, set pkgver, sha512 sum and pkgrel + fix permissions
sed -i -r -e 's~pkgver=.*~pkgver='"$PKG_VERSION"'~' PKGBUILD
sed -i -r -e 's~sha512sums=.*~sha512sums=\("'"$sum"'"\)~' PKGBUILD
sed -i -r -e 's~pkgrel=.*~pkgrel='"$PKG_REL"'~' PKGBUILD

# Cleanup + fix permissions
rm .SRCINFO
su pcr -c "makepkg --printsrcinfo" > .SRCINFO
chown -R pcr:pcr .SRCINFO

# Push changes
mygit add .SRCINFO PKGBUILD
mygit commit -m "Bump to $PKG_VERSION"
mygit push origin master
