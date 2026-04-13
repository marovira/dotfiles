#!/bin/sh

cur_os=$(uname)

# nvim
rm "$HOME/.config/nvim"

# git
rm "$HOME/.gitconfig"
rm "$HOME/.gitignore"

# zsh
rm "$HOME/.zshenv"
rm "$HOME/.config/zsh"
rm "$HOME/.config/zsh-patina"

# Language files
if [ -f "$HOME/.clang-format" ]; then
    rm "$HOME/.clang-format"
fi

# bat
rm "$HOME/.config/bat"

# wezterm
rm "$HOME/.config/wezterm"

if [[ "$cur_os" != "Darwin" ]]; then
    rm "$HOME/.tmux.conf"
    rm -rf "$HOME/.tmux"
fi
