#!/bin/sh
#vim:set et sw=2 ts=4 tw=84:

ln --backup -s "$PWD/zsh/zshrc" "$HOME/.zshrc"
ln --backup -s "$PWD/zsh/zsh_plugins" "$HOME/.zsh_plugins.txt"
ln --backup -s "$PWD/zsh/p10k.zsh" "$HOME/.p10k.zsh"
ln --backup -s "$PWD/zsh/zlogin" "$HOME/.zlogin"
ln --backup -s "$PWD/zsh/zshfn" "$HOME/.zshfn"
ln --backup -s "$PWD/git/config" "$HOME/.gitconfig"
ln --backup -s "$PWD/git/ignore" "$HOME/.gitignore"
ln --backup -s "$PWD/git/template" "$HOME/.gittemplate.txt"
ln --backup -s "$PWD/nvim" "$HOME/.config/nvim"
ln --backup -s "$PWD/cpp/.clang-format" "$HOME/.clang-format"
ln --backup -s "$PWD/tmux/tmux.conf" "$HOME/.tmux.conf"
ln --backup -s "$PWD/bat" "$HOME/.config/bat"
ln --backup -s "$PWD/wezterm" "$HOME/.config/wezterm"

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
