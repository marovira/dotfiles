# Windows Installation

> **NOTE:**
> If the PC is a work computer, don't add folders to the global path. Instead add them to
> the user path. This does require logging off and on for the changes to take effect, but
> it is the more secure option.

## Initial Setup

Download and install the following software:

1. Download **64-bit** [Neovim](https://github.com/neovim/neovim/releases) (MSI installer
   is recommended) and install it. Default installation path is fine.
2. Download and install [Git](https://git-scm.com/downloads). Make sure that everything is
   added to the path.
3. Download Windows Terminal from the Windows app store.
4. Download and install [Python](https://www.python.org/downloads/). Latest version of
   Python is usually fine unless parity is required with another OS.
4. Download [Neovide](https://neovide.dev/) and add it to path (I think it's added
   automatically).

### Additional Dependencies

The following tools are also required for optimal functionality:

1. Download the latest release for
   [ripgrep](https://github.com/BurntSushi/ripgrep/releases). The MSVC version is
   recommended. Unzip the archive and copy `rg.exe` to C:/Program Files/Git/usr/bin
2. Download the latest release for [fd](https://github.com/sharkdp/fd/releases). MSVC
   version is recommended. Unzip the archive and copy `fd.exe` to
   C:/Program Files/Git/usr/bin.
3. Download the latest release for
   [stylua](https://github.com/JohnnyMorganz/StyLua/releases). Create a new folder under
   C:/Program Files/stylua and extract the contents of the archive in there. Add this
   folder to path.
4. Download [FiraCode
   NerdFont](https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/FiraCode)
   and install it. Regular version is recommended.
5. Download the latest release for [bat](https://github.com/sharkdp/bat/releases). The
   MSVC version is recommended. Unzip the archive and copy `bat.exe` to
   C:/Program Files/Git/usr/bin.

### Installing ZSH

ZSH can be installed with Git, but it does require a bit more work to set up. First,
download the latest version of ZSH from
[here](https://packages.msys2.org/package/zsh?repo=msys&variant=x86_64). The package can
then be extracted with WinRAR. Once it is extracted, copy the following:

1. Copy the `etc` folder to C:/Program Files/Git/etc
2. Copy the `usr` folder to C:/Program Files/Git/usr

## Installing dotfiles

Once everything has been installed, clone this repository and run `install.bat` as admin.

## Post-build Steps

### Creating a SSH Key

Run `ssh-keygen` from bash using default settings (and default password). Once that is
done, ZSH will automatically start the agent.

### Fixing Antidote

After installation, open Terminal and let antidote get installed. There will (most likely)
be a ton of errors coming out from the mangled paths. To fix this, go to
%USERPROFILE%/.antidote/functions and open `__antidote_get_cachedir`. Then add the
following:

```zsh
  elif [[ "${OSTYPE}" == (cygwin|msys)* ]]; then
    result=$(cygpath ${LOCALAPPDATA:-$LocalAppData}) # <-- This line
```

Now close the terminal and open it again. You may need to delete
%USERPROFILE%/.zsh_plugins.zsh to force antidote to re-download the files, but after that
ZSH should work successfully.

### Adding Python venv for Nvim

Open a terminal and navigate to %USERPROFILE% and enter `python -m venv nvim`. This will
create a virtual environment for neovim. Now activate the environment with `.
nvim/Scripts/activate` and run `pip install pynvim`. Once it is installed, enter
`deactivate` to disable the virtual environment.

> **NOTE:**
> This setup now implies that all Python projects *MUST* use a virtual environment, since
> nvim will now pull the state correctly. It is worth noting that once a virtual
> environment is active, starting vi or neovide will pull the state with it.

### Adding Neovide to Context Menu

On first run of Neovide (after it finishes installing everything), run
`:NeovideRegisterRightClick` to register the right-click option in the context menu.

## Extra Software

### C/C++ Support

To allow C/C++ syntax highlighting as well as compilation, we need `clang` and
`clang-format`, which will be installed as part of Clang itself. To install it, go
[here](https://github.com/llvm/llvm-project/releases) and download the required version.
Make sure it gets added to the path.

### Markdown

Markdown requires pandoc, which can be downloaded from
[here](https://github.com/jgm/pandoc/releases). Also add it to the path.

### LaTeX

Requires MiKTeX and a PDF viewer that doesn't block the file. Install the following:

1. MiKTeX can be downloaded from [here](https://miktex.org/download). Add to path.
2. Download [SumatraPDF](https://www.sumatrapdfreader.org/download-free-pdf-viewer) and
   add to path.
