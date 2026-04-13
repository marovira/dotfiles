#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

source "$SCRIPT_DIR/common.sh"

# Ensure that .config exists
mkdir -p "$HOME/.config"

# nvim
mklink "$SCRIPT_DIR/nvim" "$HOME/.config/nvim"

# git
mklink "$SCRIPT_DIR/git/config" "$HOME/.gitconfig"
mklink "$SCRIPT_DIR/git/ignore" "$HOME/.gitignore"

# zsh
mklink "$SCRIPT_DIR/zsh/zshenv" "$HOME/.zshenv"
mklink "$SCRIPT_DIR/zsh" "$HOME/.config/zsh"
mklink "$SCRIPT_DIR/zsh/zsh-patina" "$HOME/.config/zsh-patina"

# bat
mklink "$SCRIPT_DIR/bat" "$HOME/.config/bat"

# wezterm
mklink "$SCRIPT_DIR/wezterm" "$HOME/.config/wezterm"

# tmux (Linux only)
if [[ "$cur_os" != "Darwin" ]]; then
    mkdir -p "$HOME/.tmux/"
    mklink "$SCRIPT_DIR/tmux/tmux.conf" "$HOME/.tmux.conf"
    mklink "$SCRIPT_DIR/tmux/themes" "$HOME/.tmux/themes"

    if [[ ! -d "$HOME/.tmux/plugins/tpm" ]]; then
        git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    fi
fi
