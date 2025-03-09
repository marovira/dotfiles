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

* Default editor: Vim (will be overridden by `gitconfig`)
* Override default branch name to `master`. If this is a work PC, use whatever standard is
  used there.
* Select "Git from the command line and also from 3rd-party software". Remaining Linux
  environment will be set by msys2.
* Use external OpenSSH
* Use OpenSSL
* Checkout as-is, commit Unix-style. If this is a work PC, use whatever standard is used
  there.
* Remaining options to default value as appropriate.

### Install Scoop Packages

Open a terminal (doesn't matter which) run `scoop bucket add extras`. Then, using `scoop
install`, install the following packages:

* `cmake`
* `delta`
* `fd`
* `llvm`
* `msys2`
* `neovide`
* `neovim`
* `python`
* `ripgrep`
* `stylua`
* `tree-sitter`
* `zstd`

> [!NOTE]
> If python will be used for development, then also install `uv`


### Setting up `msys2`

After scoop has finished installing everything, run `msys2` to finish setting up the
environment. Once that is done, open the settings for Windows Terminal and create a new
profile with the following settings:

* Name: MSYS2
* Command line: `%USERPROFILE%\scoop\apps\msys2\current\msys2_shell.cmd -defterm -here
  -no-start -ucrt64 -use-full-path`
* Starting directory: use whatever is appropriate
* Icon: `%USERPROFILE%\scoop\apps\msys2\current\msys2.ico`

Set this profile as default and restart terminal. If everything is correctly set, the
UCRT64 bash from msys2 should show up. Run `pacman -Suu` to ensure there aren't any
updates and now install with `pacman -S`:

* `zsh`
* `util-linux`
* `pv`
* `openssh`

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
