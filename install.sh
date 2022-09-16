#!/bin/sh
#vim:set et sw=2 ts=4 tw=84:

ln --backup -s "$PWD/zsh/zshrc" "$HOME/.zshrc"
ln --backup -s "$PWD/git/config_linux" "$HOME/.gitconfig"
ln --backup -s "$PWD/git/ignore" "$HOME/.gitignore"
ln --backup -s "$PWD/git/template" "$HOME/.gittemplate.txt"
ln --backup -s "$PWD/nvim" "$HOME/.config/nvim"
ln --backup -s "$PWD/cpp/.clang-format" "$HOME/.clang-format"
ln --backup -s "$PWD/python/pylintrc" "$HOME/pylintrc"
