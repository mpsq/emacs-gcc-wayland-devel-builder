#
# This Dockerfile is used to build the image "mpsq/emacs-builder".
# https://hub.docker.com/r/mpsq/emacs-builder
#
# This image is then used in GitHub actions to compile Emacs.
#
FROM archlinux:base-devel

ARG UPSTREAM_BRANCH
ARG UPSTREAM_REPO
ARG USR
ARG USR_HOME

ENV CC="/usr/bin/clang" \
  CXX="/usr/bin/clang++" \
  CPP="/usr/bin/clang -E" \
  LD="/usr/bin/lld" \
  AR="/usr/bin/llvm-ar" \
  AS="/usr/bin/llvm-as" \
  CFLAGS="-g -flto -fuse-ld=lld" \
  CXXFLAGS="-g -flto -fuse-ld=lld"

COPY assets/ /assets/
COPY scripts/ /scripts/

RUN \
  pacman -Syu --noconfirm && \
  pacman -U --noconfirm /assets/libgccjit-10.2.0-2-x86_64.pkg.tar.zst && \
  pacman -S --noconfirm \
  # Emacs deps
  alsa-lib \
  cairo \
  clang \
  binutils \
  gnutls \
  gpm \
  gtk3 \
  harfbuzz \
  jansson \
  libotf \
  libxml2 \
  lld \
  llvm \
  webkit2gtk \
  xorgproto \
  # Pipeline deps
  bc \
  expac \
  git \
  jq \
  openssh

RUN \
  groupadd -r "$USR" && useradd --no-log-init -r -g "$USR" "$USR" && \
  mkdir "$USR_HOME" && \
  chown -R "$USR":"$USR" "$USR_HOME" && \
  echo "$USR ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/user && \
  chmod 0440 /etc/sudoers.d/user

WORKDIR $USR_HOME

USER $USR

SHELL ["/bin/bash", "-c"]

# We compile Emacs in order to cache artifacts in the image and get better
# compilation time in subsequent builds.
RUN \
  cp /scripts/pull.bash . && \
  cp /assets/PKGBUILD . && \
  ./pull.bash && \
  makepkg && \
  rm emacs-1-1-x86_64.pkg.tar.zst
