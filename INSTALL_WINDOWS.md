# Windows Installation

> [!NOTE]
> If the PC is a work computer, don't add folders to the global path. Instead add them to
> the user path. This does require logging off and on for the changes to take effect, but
> it is the more secure option.

## Initial Setup

Download and install the following software:

1. Download Windows Terminal from the Windows app store.
2. Install [scoop](https://scoop.sh). Note that this *needs* to be done from a Powershell
   terminal. Admin privileges are not required.
3. Download [FiraCode
   NerdFont](https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/FiraCode)
   and install it. Regular version is recommended.

### Install Git

Download the latest release from [here](https://git-scm.com/downloads). When installing,
use the following options:

* If using a work PC, override default branch to be whatever standard is used there.
  Otherwise, set to `master`.
* Ensure that *all* of git is added to path.
* Remaining options may be left as default or modified as appropriate.

### Install Scoop Packages

Open a terminal (doesn't matter which) run `scoop bucket add extras`. Then, using `scoop
install`, install the following packages:

* `bat`
* `cmake`
* `delta`
* `fd`
* `llvm`
* `neovide`
* `neovim`
* `python`
* `ripgrep`
* `stylua`
* `tree-sitter`
* `zstd`
* `wezterm`

> [!NOTE]
> If python will be used for development, then also install `uv`


## Installing dotfiles

Once everything has been installed, clone this repository and run `install.bat` as admin.


## Post-build Steps

### Setting up `pacman`

1. Open an admin terminal running git bash and run `sh install_pacman.sh` from this
   repository.
2. Run `pacman -Suu` to update everything.

Once `pacman` is correctly installed, open another admin terminal and install:

* `zsh`
* `util-linux`
* `pv`
* `tree`

> [!NOTE]
> Errors during install referring to `man` are normal as it is not actually installed.

> [!NOTE]
> In newer versions, it is possible for `pacman -Suu` to fail with the following error
> message: `/etc/inputrc exists in both 'libreadline' and 'mingw-w64-x86_64-git-extra'`.
> If this happens, run `pacman -Suu --overwrite /etc/inputrc`. 

> [!WARNING]
> 1. It is possible that conflicts between packages occur on installation. I believe this
>    is caused by mismatches between whatever git installs and what pacman pulls down. In
>    that case, usually installing the latest pre-release version solves the issue.
> 2. When updating git, it is entirely possible that mismatches occur again. The only
>    solution I've found so far is to uninstall Git (removing the folder) and then
>    installing everything again.

> [!NOTE]
> Once `wezterm` is installed and fully configured, Windows Terminal can be left alone and
> only used when strictly necessary.

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
