#
# This Dockerfile is used to build the image "mpsq/emacs-builder".
# Link: https://hub.docker.com/repository/docker/mpsq/emacs-builder
#
# What is the point of this?
#   - Have an Archlinux environment
#   - Pull and compile Emacs so it is much faster to produce subsequent binaries
#
# This image is obviously then used in the GitHub action to compile Emacs.
#
# At the moment, this image is built manually from times to times (= very
# infrequently). In the future, I might get CI to do it, maybe on a monthly
# basis.
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

RUN \
  cp /scripts/pull.bash . && \
  cp /assets/PKGBUILD . && \
  ./pull.bash && \
  makepkg && \
  rm emacs-1-1-x86_64.pkg.tar.zst
