#!/bin/sh
#vim:set et sw=2 ts=4 tw=84:

ln -s "$PWD/zsh/zshrc" "$HOME/.zshrc"
ln -s "$PWD/zsh/zsh_plugins" "$HOME/.zsh_plugins.txt"
ln -s "$PWD/zsh/p10k.zsh" "$HOME/.p10k.zsh"
ln -s "$PWD/zsh/zlogin" "$HOME/.zlogin"
ln -s "$PWD/zsh/zshfn" "$HOME/.zshfn"
ln -s "$PWD/git/config_linux" "$HOME/.gitconfig"
ln -s "$PWD/git/ignore" "$HOME/.gitignore"
ln -s "$PWD/git/template" "$HOME/.gittemplate.txt"
ln -s "$PWD/nvim" "$HOME/.config/nvim"
ln -s "$PWD/cpp/.clang-format" "$HOME/.clang-format"
ln -s "$PWD/tmux/tmux.conf" "$HOME/.tmux.conf"

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
