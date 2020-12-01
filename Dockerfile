FROM mpsq/emacs-native-comp-wayland-builder:latest

RUN trizen \
  --quiet \
  --nocolors \
  --noedit \
  --noconfirm \
  --noinstall \
  --movepkg-dir=/home/pcr \
  -S emacs-native-comp-git-enhanced
