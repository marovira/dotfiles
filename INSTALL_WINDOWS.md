# Windows Installation

> [!NOTE]
> If the PC is a work computer, don't add folders to the global path. Instead add them to
> the user path. This does require logging off and on for the changes to take effect, but
> it is the more secure option.

## Initial Setup

Download and install the following software:

1. Download and install [Git](https://git-scm.com/downloads). Make sure that everything is
   added to the path.
2. Download Windows Terminal from the Windows app store.
3. Install [scoop](https://scoop.sh). Note that this *needs* to be done from a Powershell
   terminal. Admin privileges are not required.
4. Download [FiraCode
   NerdFont](https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/FiraCode)
   and install it. Regular version is recommended.

### Install Chocolatey Packages

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

Open an admin terminal with git and execute the following code (may be copied in):

```sh
pacman="
pacman-6.0.1-32-x86_64.pkg.tar.zst
pacman-mirrors-20240523-1-any.pkg.tar.zst
msys2-keyring-1~20240410-2-any.pkg.tar.zst
"
curl https://raw.githubusercontent.com/msys2/MSYS2-packages/7858ee9c236402adf569ac7cff6beb1f883ab67c/pacman/pacman.conf -o /etc/pacman.conf
for f in $pacman; do curl https://repo.msys2.org/msys/$HOSTTYPE/$f -fo ~/Downloads/$f; done

cd /
# If any of these fail, manually extract the files into their corresponding directories.
tar x --zstd -vf ~/Downloads/msys2-keyring-1~20220623-1-any.pkg.tar.zst usr
tar x --zstd -vf ~/Downloads/pacman-mirrors-20220205-1-any.pkg.tar.zst etc
tar x --zstd -vf ~/Downloads/pacman-6.0.1-18-x86_64.pkg.tar.zst usr
mkdir -p /var/lib/pacman

pacman-key --init
pacmak-key --populate msys2
pacman -Syu
URL=https://github.com/git-for-windows/git-sdk-64/raw/main
cat /etc/package-versions.txt | while read p v; do d=/var/lib/pacman/local/$p-$v;
 mkdir -p $d; echo $d; for f in desc files install mtree; do curl -sSL "$URL$d/$f" -o $d/$f;
 done; done

pacman-key --refresh-keys
```

> [!NOTE]
> If any of the `curl` calls for the pacman packages result in a 404 error, then go to the
> [msys2](https://repo.msys2.org/msys/x86_64/) page and search for the package names,
> adjusting the paths to use the latest versions.

### Installing Pacman packages

Once pacman is installed, on the same admin terminal install the following using `pacman
-S`:

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
