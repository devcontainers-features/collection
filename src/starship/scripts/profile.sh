#!/bin/sh

# Initialize starship for the current shell
case "$0" in
  *zsh)
    eval "$(starship init zsh)"
    ;;
  *bash|*)
    eval "$(starship init bash)"
    ;;
esac
