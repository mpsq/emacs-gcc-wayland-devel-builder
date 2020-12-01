FROM archlinux:base-devel

WORKDIR /temp

COPY deps .

RUN pacman -Syu --noconfirm && \
  pacman -U --noconfirm libgccjit-10.2.0-2-x86_64.pkg.tar.zst && \
  pacman -S --noconfirm git jq expac && \
  groupadd -r pcr && useradd --no-log-init -r -g pcr pcr && \
  mkdir /pcr && \
  mkdir /home/pcr && \
  chown -R pcr:pcr /pcr && \
  chown -R pcr:pcr /home/pcr && \
  echo "pcr ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/user && \
  chmod 0440 /etc/sudoers.d/user

USER pcr

WORKDIR /pcr

RUN git clone https://aur.archlinux.org/trizen.git && \
  cd trizen && \
  makepkg -si --noconfirm

RUN trizen --quiet --nocolors --noedit --noconfirm --noinstall --movepkg-dir=/home/pcr -S emacs-native-comp-git-enhanced
