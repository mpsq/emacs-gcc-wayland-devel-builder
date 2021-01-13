pkgname=emacs
pkgver=1
pkgrel=1
pkgdesc="The extensible, customizable, self-documenting real-time display editor"
arch=('x86_64')
url="https://www.gnu.org/software/emacs/emacs.html"
license=('GPL3')
depends=()
source=()
sha1sums=()

build() {
  cd /home/pcr/emacs

  [[ -x configure ]] || ( ./autogen.sh git && ./autogen.sh autoconf )

  _conf=(
    --prefix=/usr
    --sysconfdir=/etc
    --libexecdir=/usr/lib
    --localstatedir=/var
    --mandir=/usr/share/man
    --with-gameuser=:games
    --with-sound=alsa
    --with-modules
    --with-x-toolkit=gtk3
    --with-cairo
    --with-xwidgets
    --with-nativecomp
    --with-pgtk
    --without-compress-install
    --without-gconf
    --without-gsettings
    --without-m17n-flt
    --enable-autodepend
    --enable-link-time-optimization
  )

  ./configure --with-nativecomp CC='clang' "${_conf[@]}"

  make -j$(nproc)
}

package() {
  cd /home/pcr/emacs
  make DESTDIR="$pkgdir" install

  mv "$pkgdir"/usr/bin/{ctags,ctags.emacs}
  mv "$pkgdir"/usr/share/man/man1/{ctags.1,ctags.emacs.1};

  # fix user/root permissions on usr/share files
  find "$pkgdir"/usr/share/emacs/ | xargs chown root:root

  # fix permssions on /var/games
  mkdir -p "$pkgdir"/var/games/emacs
  chmod 775 "$pkgdir"/var/games
  chmod 775 "$pkgdir"/var/games/emacs
  chown -R root:games "$pkgdir"/var/games
}
