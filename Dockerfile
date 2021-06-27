#
# This Dockerfile is used to build the image "mpsq/emacs-builder".
# https://hub.docker.com/r/mpsq/emacs-builder
#
# This image is then used in GitHub actions to compile Emacs.
#
FROM archlinux:base-devel

# See ./assets/variables
ARG UPSTREAM_BRANCH
ARG UPSTREAM_REPO
ARG USR
ARG USR_HOME

COPY assets/ /assets/
COPY scripts/ /scripts/

# This is a requirement for pushd/popd + ./scripts/pull.bash script
SHELL ["/bin/bash", "-l", "-euxo", "pipefail", "-c"]

RUN \
  # Compilation flags for faster builds
  MAKEFLAGS="-j$(nproc)" && \
  export MAKEFLAGS && \
  # Install deps
  pacman -Syu --noconfirm && \
  pacman -S --noconfirm \
  # Emacs deps
  alsa-lib cairo clang binutils gnutls gpm gtk3 harfbuzz jansson libotf \
  libxml2 lld llvm webkit2gtk xorgproto \
  # GitHub Actions deps
  bc expac git jq openssh \
  # yay dep
  go && \
  # Add $USR user / group with sudo access (required by yay)
  groupadd -r "$USR" && \
  useradd --no-log-init -r -g "$USR" "$USR" && \
  mkdir -p "$USR_HOME"/.gnupg && \
  cp /assets/gpg.conf "$USR_HOME"/.gnupg/gpg.conf && \
  chmod 700 "$USR_HOME"/.gnupg && \
  chmod 600 "$USR_HOME"/.gnupg/* && \
  chown -R "$USR":"$USR" "$USR_HOME" && \
  echo "$USR ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/user && \
  chmod 0440 /etc/sudoers.d/user && \
  # Install yay
  pushd "$USR_HOME" && \
  su "$USR" -c "git clone --depth=1 https://aur.archlinux.org/yay.git" && \
  pushd yay && \
  su "$USR" -c "makepkg -si --noconfirm" && \
  popd && \
  # Install 'su-exec'. This utility replaces 'su USR -c ""'. The main advantage
  # is that it does not spawn a child and therefore shares environment variables
  # with the current shell
  su "$USR" -c "yay -S su-exec --noconfirm" && \
  # Install libgccjit
  su-exec "$USR" yay -S libgccjit --noconfirm && \
  # Copy needed files to $USR_HOME/
  su-exec "$USR" cp /scripts/pull.bash . && \
  su-exec "$USR" cp /assets/PKGBUILD . && \
  # Pull Emacs from git repository
  su-exec "$USR" ./pull.bash && \
  # Compile Emacs in order to cache artifacts in the image and get better
  # compilation time in subsequent builds
  su-exec "$USR" makepkg && \
  # Cleanup
  rm -rf /var/cache/ .cache yay emacs-1-1-x86_64.pkg.tar.zst && \
  su-exec "$USR" yay -Rcns --noconfirm go && \
  su-exec "$USR" yay -Scc --noconfirm

WORKDIR $USR_HOME
