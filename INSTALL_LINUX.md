# Linux Installation

## Initial Setup

Using the package manager, install the following:

* zsh
* neovim
* git
* Python 3
* tmux
* bat
* fd `sudo apth install fd-find`
* ripgrep
* python<ver>-venv (where <ver> is the version of Python installed. For example, for
  Python 3.10.xx, the package is python3.10-venv)

## Installing dotfiles

Once everything is installed, clone this repository and run `install.sh`.

## Post-build Steps

### Creating a SSH Key

Run `ssh-keygen` using default settings (and default password). Once that is done, ZSH
will automatically start the agent.

### Adding Python venv for Nvim

Open a terminal and navigate to the home directory. Run `python3 -m venv nvim` and
activate the environment with `. nvim/bin/activate`. Then run `pip install pynvim`. Once
it is installed, enter `deactivate` to disable the virtual environment.

## Troubleshooting

1. Make sure the installation script runs **before** the switch to ZSH is made. This
   ensures files already exist prior to the first time ZSH is run. To switch shells, just
   enter `chsh -s $(which zsh)`.
2. If plugins aren't loaded (it becomes immediately apparent from the command line),
   double-check whether `~/.zsh_plugins.zsh` is empty. If it is, delete it and restart the
   shell. This will force antidote to install everything.
3. The installation script will automatically clone TPM (plugin manager for TMUX) into the
   corresponding directory. When opening TMUX for the first time, create a split `<prefix>
   |` and see if Vim bindings for switching splits work. If not, then try:
   * `tmux source ~/.tmux.conf`, or
   * `tmux run ~/.tmux/plugins/tpm/tpm`

### Installing Neovide

If a UI for nvim is required, then install
[neovide](https://neovide.dev/installation.html). Snap is the recommended way of
installing it. Once that is done, download [FiraCode
NerdFont](https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/FiraCode) and
install it.
