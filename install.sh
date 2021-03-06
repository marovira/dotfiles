#!/bin/sh
#vim:set et sw=2 ts=4 tw=84:

ln --backup -s "$PWD/zsh/zshrc" "$HOME/.zshrc"
ln --backup -s "$PWD/git/config" "$HOME/.gitconfig"
ln --backup -s "$PWD/git/ignore" "$HOME/.gitignore"
ln --backup -s "$PWD/git/template" "$HOME/.gittemplate.txt"
ln --backup -s "$PWD/nvim" "$HOME/.config/nvim"
