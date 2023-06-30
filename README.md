# Dotfiles

The source of all my config files.

## Initial Setup

### Windows

1. Download **64-bit** [Neovim](https://github.com/neovim/neovim/releases) (MSI installer
   is recommended) and install it. Default installation path is fine.
2. Download and install [Git](https://git-scm.com/downloads). Make sure that everything is
   added to the path.
3. Download Windows Terminal from the Windows app store.
4. Download and install [Python](https://www.python.org/downloads/). Latest version of
   Python is usually fine unless parity is required with another OS.
4. Download [Neovide](https://neovide.dev/) and add it to path (I think it's added
   automatically).
5. Download the latest released for [ripgrep](https://github.com/BurntSushi/ripgrep) and
   [fd](https://github.com/sharkdp/fd). Extract the folders and add them to the path.
6. Clone this repository.
7. Run `install.bat` as admin.
8. On first open of Neovide, run `NeovideRegisterRightClick` to register the right-click
   option in the context menu.

### Linux

1. Using the package manager, install:
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
2. Clone this repository.
3. Run `install.sh`

Before running neovim, do the following:

1. Switch to the home directory and run `python3 -m venv nvim`
2. Activate the environment with `. nvim/bin/activate`
3. Run `pip install pynvim`
4. Deactivate the environment with `deactivate`

**Notes:**

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

### OSX

1. Download and install [homebrew](https://docs.brew.sh/Installation)
2. Using brew, install the same packages as Linux.
3. Clone this repository.
3. Run install_mac.sh

**Notes:**

1. Setup is almost identical to Linux, just using brew instead of the default package
   manager.
2. As of now, tmux crashes on start. I haven't been able to figure out why this happens,
   but it may just resolve itself eventually.


## Vim Plug-in Dependencies

Once the base installation of Vim is up and running, we can focus on the dependencies
needed for each plug-in. Most of them will work as is, but a few will need a bit more
work.

### CTags

* For Windows, go [here](https://github.com/universal-ctags/ctags-win32/releases) and
  download the latest version. Make sure it gets added to the path.
* For Linux, install `ctags`.

### C/C++

This needs two things: `clang` and `clang-format`. Both of these will be installed by
default upon installation of Clang itself:

* For Windows, go [here](https://github.com/llvm/llvm-project/releases) and download the
  required version. Make sure it gets added to the path.
* For Linux, install `clang`. If this doesn't install `clang-format`, install it as well.

### Python

In order to make nvim play nice with virtual environments, there's going to be some more
setup involved depending on the OS. For Windows, run:

```sh
pip install pynvim pylint jedi black
```

This will install all required packages for development.

> **Note:**
> When running neovide in Windows, it will use the system-wide Python (as far as I know
> there's no way to change this) so you must ensure that any packages are installed
> system-wide for pylint and jedi to work properly. Virtual environments should still be
> used to run actual python code.

For Linux, do the following:

1. Go to the home directory and activate the `nvim` environment.
2. Run `pip install jedi`
3. Deactivate the environment.

This allows us to have auto-complete for Python. To enable linting and formatting, ensure
that those are installed in the virtual environment for the specific project.

### Markdown

This will require Pandoc.

* For Windows, go [here](https://github.com/jgm/pandoc/releases/tag/2.19.2) and download
  the latest version. Make sure it gets added to the path.
* For Linux, install `pandoc`.

### LaTeX

This is going to need a LaTeX engine and a PDF viewer.

* For Windows, first install MiKTeX from [here](https://miktex.org/download). Once that is
  done, download SumatraPDF from
  [here](https://www.sumatrapdfreader.org/download-free-pdf-viewer). Make sure that
  SumatraPDF is added to the path. Once that is done, things will just work.
* For Linux... unknown. Update if/when we need it.

## Clang-format

This repo also contains the main clang-format used by all my projects. Whenever an update
occurs, make sure it makes its way here so we can keep track of changes at a more global
scale.
