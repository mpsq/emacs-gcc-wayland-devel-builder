# Emacs with native compilation ("gcc") + Wayland support

If the answer to those is "yes":

- Do you want to use Emacs with native compilation enabled?
- Do you want to use Emacs with Wayland support?
- Are you using Arch Linux?

Then you might be interested in this repository. If you want all of those but
you are not using Arch Linux, you can still go to the
[release page](https://github.com/mpsq/emacs-gcc-wayland-devel-builder/releases)
and grab the latest binaries.

# What is this?

This repository is just a factory that creates Emacs binaries for `x64` so you
don't have to do it yourself. The base Emacs branch that this repo builds can be
found at [github.com/flatwhatson/emacs](https://github.com/flatwhatson/emacs).

Arch Linux users can install the binaries directly from `AUR` using the
[emacs-gcc-wayland-devel-bin](https://aur.archlinux.org/packages/emacs-gcc-wayland-devel-bin/)
package.

# I want to improve X

Please create an issue (or, even better, a PR).

# Thanks

All the hard work is done by other people:

- [github.com/masm11](https://github.com/masm11) for the Wayland support
- [github.com/flatwhatson](https://github.com/flatwhatson) for maitaining a
  [clean branch](https://github.com/flatwhatson/emacs) with Wayland support
- [github.com/VitalyAnkh](https://github.com/VitalyAnkh) for
  [emacs-native-comp-git-enhanced](https://aur.archlinux.org/packages/emacs-native-comp-git-enhanced/)
- Obviously [core Emacs maintainers](https://www.gnu.org/people/people.en.html)!

# Related

[github.com/fejfighter/pgtk-emacs-flatpak](https://github.com/fejfighter/pgtk-emacs-flatpak)
is the same as this repository but based on Flatpak.
