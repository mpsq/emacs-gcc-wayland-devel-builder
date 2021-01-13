#!/usr/bin/env bash

if [[ -d "emacs" ]]; then
  cd emacs
  git pull --rebase origin pgtk-nativecomp
else
  git clone --depth=1 https://github.com/flatwhatson/emacs
  cd emacs
fi
