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

# nvim
mklink "$PWD/nvim" "$HOME/.config/nvim"

# git
mklink "$PWD/git/config" "$HOME/.gitconfig"
mklink "$PWD/git/ignore" "$HOME/.gitignore"

# zsh
mklink "$PWD/zsh/zshenv" "$HOME/.zshenv"
mklink "$PWD/zsh" "$HOME/.config/zsh"

# bat
mklink "$PWD/bat" "$HOME/.config/bat"

# wezterm
mklink "$PWD/wezterm" "$HOME/.config/wezterm"

# tmux (Linux only)
if [[ "$cur_os" != "Darwin" ]]; then
    mkdir -p "$HOME/.tmux/"
    ln --backup -s "$PWD/tmux/tmux.conf" "$HOME/.tmux.conf"
    ln --backup -s "$PWD/tmux/themes" "$HOME/.tmux/themes"

    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi
