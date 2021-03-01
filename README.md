<!-- prettier-ignore-start -->
<div align="center">
    <img src=".github/icon.svg" width="200" />
</div>
<!-- prettier-ignore-end -->

# Emacs with native compilation ("gcc") and Wayland support

Because [native-comp](https://www.emacswiki.org/emacs/GccEmacs) is
[fast](https://akrl.sdf.org/gccemacs.html),
[Wayland/GTK3 support](https://github.com/masm11/emacs) means optimal HiDPI,
cleaner/simpler dependencies, no XWayland, etc. This package is also a
convenient way of using the "devel" version of Emacs without having to compile
it yourself.

Note: we do not patch / amend or modify Emacs directly, this is a _vanilla_
binary of Emacs with specific compilation flags.

# How to get it

## Arch Linux

Use the `AUR`
[package](https://aur.archlinux.org/packages/emacs-gcc-wayland-devel-bin/):

```sh
yay -S emacs-gcc-wayland-devel-bin # or any other AUR helper
```

## Others

If you are not using Arch Linux, you can still go to the
[release page](https://github.com/mpsq/emacs-gcc-wayland-devel-builder/releases)
and grab the latest binaries.

Based on demand, I might add compiled packages for other Linux distributions, if
you are interested, let me know in the
[issues](https://github.com/mpsq/emacs-gcc-wayland-devel-builder/issues).

# I want to improve X

Please create an issue (or, even better, a PR).

# Thanks

- [github.com/masm11](https://github.com/masm11) for the Wayland support
- [github.com/flatwhatson](https://github.com/flatwhatson) for maintaining a
  [clean branch](https://github.com/flatwhatson/emacs) with Wayland support
- Obviously [core Emacs maintainers](https://www.gnu.org/people/people.en.html)!

# Related

[github.com/fejfighter/pgtk-emacs-flatpak](https://github.com/fejfighter/pgtk-emacs-flatpak)
is similar but based on Flatpak.
