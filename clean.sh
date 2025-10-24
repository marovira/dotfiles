#!/bin/sh

cur_os=$(uname)

# ZSH
rm "$HOME/.zshenv"
rm "$HOME/.config/zsh"

# Git
rm "$HOME/.gitconfig"
rm "$HOME/.gitignore"
rm "$HOME/.gittemplate.txt"

# Nvim
rm "$HOME/.config/nvim"

# Language files
rm "$HOME/.clang-format"

# Bat
rm "$HOME/.config/bat"

# WezTerm
rm "$HOME/.config/wezterm"

if [[ "$cur_os" != "Darwin" ]]; then
    rm "$HOME/.tmux.conf"
    rm -rf "$HOME/.tmux"
fi
