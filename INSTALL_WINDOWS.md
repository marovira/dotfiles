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

> [!NOTE]
> If python will be used for development, then also install `uv`

> [!IMPORTANT]
> Care needs to be taken when updating Git, as we're using a heavily modified environment.
> As scoop will effectively move the installation folder to the one with the new version,
> `pacman` needs to be re-installed alongside the tools it manages. Other than that,
> everything else should work normally.

## Installing dotfiles

Once everything has been installed, clone this repository and run `install.bat` as admin.

## Post-build Steps

### Setting up `pacman`

1. Open a terminal running git bash and run `sh install_pacman.sh` from this
   repository.
1. Run `pacman -Suu` to update everything.

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

> [!NOTE]
> Once `wezterm` is installed and fully configured, Windows Terminal can be left alone and
> only used when strictly necessary.

> [!NOTE]
> It is recommended to use the post-install script in the git folder to install pacman and
> correctly configure git. I'm leaving the full instructions here in the event that the
> script has to be avoided.


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

In the specific case of Windows, it may be preferable to always use LF, in which case this
should also be set:

```sh
git config --system core.autocrlf input
```

> [!NOTE]
> These settings can be set using the post-install script for Windows. These instructions
> are here in case it needs to be done manually.

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
