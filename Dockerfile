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

COPY deps .

RUN pacman -Syu --noconfirm && \
  pacman -U --noconfirm libgccjit-10.2.0-2-x86_64.pkg.tar.zst && \
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
  openssh && \
  groupadd -r pcr && useradd --no-log-init -r -g pcr pcr && \
  mkdir /home/pcr && \
  chown -R pcr:pcr /home/pcr && \
  echo "pcr ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/user && \
  chmod 0440 /etc/sudoers.d/user

WORKDIR /home/pcr
USER pcr

COPY PKGBUILD .
COPY pull.bash .

ENV CC="/usr/bin/clang" \
  CXX="/usr/bin/clang++" \
  CPP="/usr/bin/clang -E" \
  LD="/usr/bin/lld" \
  AR="/usr/bin/llvm-ar" \
  AS="/usr/bin/llvm-as" \
  CFLAGS="-g -flto -fuse-ld=lld" \
  CXXFLAGS="-g -flto -fuse-ld=lld"

RUN ["./pull.bash"]
RUN makepkg && \
  rm emacs-1-1-x86_64.pkg.tar.zst
