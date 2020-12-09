FROM mpsq/emacs-native-comp-wayland-builder:latest

USER pcr

RUN \
  rm /home/pcr/emacs* && \
  trizen \
  --quiet \
  --nocolors \
  --noedit \
  --noconfirm \
  --noinstall \
  --movepkg-dir=/home/pcr \
  -S emacs-native-comp-git-enhanced
