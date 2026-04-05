# Windows Installation

> [!NOTE]
> Always prefer to add to the user path instead of system-wide changes. This is especially
> important on work computers as this is more secure and negates the need for admin
> privileges.

## Initial Setup

Download and install the following software:

1. Download Windows Terminal from the Windows app store.
1. Install [scoop](https://scoop.sh). Note that this *needs* to be done from a Powershell
   terminal. Admin privileges are not required.

### Install Scoop Packages

Open the windows terminal (`cmd` is fine) and then add the following buckets with `scoop
bucket add`:

* `extras`
* `nerd-fonts`

Once that is done, install the following:

* `7zip`
* `bat`
* `cmake`
* `delta`
* `fd`
* `FiraCode-NF`
* `fzf`
* `git`
* `llvm`
* `neovide`
* `neovim`
* `python`
* `ripgrep`
* `stylua`
* `tree-sitter`
* `wezterm`
* `winrar`
* `zstd`
* `msys2`

> [!NOTE]
> If python will be used for development, then also install `uv`

## Installing dotfiles

Once everything has been installed, clone this repository and run `install.bat` as admin.

## Post-build Steps

### Setting up msys2

After `msys2` is installed, open a terminal and enter `msys2`. This will trigger the
completion of the environment setup. Once that finishes, do:

1. Run `pacman -Syuu` to update everything.
1. Run `pacman -S mingw-w64-x86_64-git` to install the git for windows version.
1. Run `pacman -S zsh pv tree openssh` to install everything else.

After this, switch to WezTerm and double-check that:

1. The ssh-agent is sourced immediately with the correct key.
1. That the start-up folder is the correct one.
1. That you can clone using ssh without having to enter the password.

If all these checks pass, then msys2 is properly configured and ready to go.

> [!NOTE]
> Once `wezterm` is installed and fully configured, Windows Terminal can be left alone and
> only used when strictly necessary.

### Creating a SSH Key

Run `ssh-keygen -a 100 -t ed25519` and create the default key using the standard ssh
password. Once it is done, restart the shell so ZSH can automatically start the ssh-agent
process.

### Git system-wide Options

Depending on the environment, it may be convenient to tell git to create new repos with a
specific default branch name. To set this at the "system" level, do:

```sh
git config --system init.defaultBranch <name>
```

> [!IMPORTANT]
> Since we're now relying on scoop to manage git itself, system-wide settings will need to
> be re-applied every time git is updated. Whenever possible, please consider moving them
> to the config itself so that we don't have to keep updating it.

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
