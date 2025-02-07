# Windows Installation

> [!NOTE]
> If the PC is a work computer, don't add folders to the global path. Instead add them to
> the user path. This does require logging off and on for the changes to take effect, but
> it is the more secure option.

## Initial Setup

Download and install the following software:

1. Download and install the *latest* version of
   [git](https://github.com/git-for-windows/git/releases). Make sure that everything is
   added to the path.
2. Download Windows Terminal from the Windows app store.
3. Install [scoop](https://scoop.sh). Note that this *needs* to be done from a Powershell
   terminal. Admin privileges are not required.
4. Download [FiraCode
   NerdFont](https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/FiraCode)
   and install it. Regular version is recommended.

### Install Scoop Packages

Open a terminal (doesn't matter which) run `scoop bucket add extras`. Then, using `scoop
install`, install the following packages:

* `main/ripgrep`
* `main/fd`
* `main/stylua`
* `main/bat`
* `main/python`
* `main/neovim`
* `extras/neovide`
* `main/delta`
* `main/llvm`
* `main/zstd`


### Setting up `pacman`

Open an admin terminal with git and run `sh install_pacman.sh` from this
repository.

> [!WARNING]
> The script to install pacman assumes that the *latest* version of Git has been installed
> (regardless of whether it's a release candidate or not). If a stable release is
> installed instead, this could lead to errors with a mismatched version of git. If this
> occurs, simply uninstall git and re-install with the latest version.

Once the script finishes, open a new admin terminal with git and run `pacman -Suu` to
update everything.

### Installing Pacman packages

Once pacman is installed and updated, using the same admin terminal, install the following
packages with `pacman -S`

* `zsh`
* `util-linux`
* `pv`

## Installing dotfiles

Once everything has been installed, clone this repository and run `install.bat` as admin.

## Post-build Steps

### Creating a SSH Key

Run `ssh-keygen -a 100 -t ed25519` and create the default key using the standard ssh
password. Once it is done, restart the shell so ZSH can automatically start the ssh-agent
process.

### Adding Python venv for Nvim

Open a terminal and navigate to %USERPROFILE% and enter `python3 -m venv nvim`. This will
create a virtual environment for neovim. Now activate the environment with `.
nvim/Scripts/activate` and run `pip install pynvim`. Once it is installed, enter
`deactivate` to disable the virtual environment.

> [!IMPORTANT]
> This setup now implies that all Python projects *MUST* use a virtual environment, since
> nvim will now pull the state correctly. It is worth noting that once a virtual
> environment is active, starting vi or neovide will pull the state with it.

### Adding Neovide to Context Menu

On first run of Neovide (after it finishes installing everything), run
`:NeovideRegisterRightClick` to register the right-click option in the context menu.

## Extra Software

### LaTeX

Requires MiKTeX and a PDF viewer that doesn't block the file. Install the following using
`scoop install`:

* `main/miktex`
* `extras/sumatrapdf`
