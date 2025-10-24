#!/bin/sh

cur_os=$(uname)

mklink() {
    if [[ "$cur_os" == "Darwin" ]]; then
        ln -s $@
    else
        ln --backup -s $@
    fi
}

# Ensure that .config exists
mkdir -p "$HOME/.config"

# ZSH
mklink "$PWD/zsh/zshenv" "$HOME/.zshenv"
mklink "$PWD/zsh" "$HOME/.config/zsh"

# Git
mklink "$PWD/git/config" "$HOME/.gitconfig"
mklink "$PWD/git/ignore" "$HOME/.gitignore"
mklink "$PWD/git/template" "$HOME/.gittemplate.txt"

# Nvim
mklink "$PWD/nvim" "$HOME/.config/nvim"

# Language files
mklink "$PWD/cpp/.clang-format" "$HOME/.clang-format"

# Bat
mklink "$PWD/bat" "$HOME/.config/bat"

# Wezterm
mklink "$PWD/wezterm" "$HOME/.config/wezterm"

# TMUX (Linux only)
if [[ "$cur_os" != "Darwin" ]]; then
    mkdir -p "$HOME/.tmux/"
    ln --backup -s "$PWD/tmux/tmux.conf" "$HOME/.tmux.conf"
    ln --backup -s "$PWD/tmux/themes" "$HOME/.tmux/themes"

    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi
