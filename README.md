# Dotfiles

The source of all my config files. Below is a (partial) set of instructions for
installing depending on the OS.

## Windows

### Setup

1. Download [Vim](https://github.com/vim/vim-win32-installer/releases) and
   install it to the root of C. **DO NOT** install to the default location! The
   spaces cause problems later on, so just install to `C:\Vim`. Also make sure
   that there is no default vimrc or vimfiles directory.
2. Download and install [Git](https://git-scm.com/downloads). Make sure that
   everything is added to the path.
3. Download and install [ConsoleZ](https://github.com/cbucher/console/releases).
   Add git bash by creating a new tab and setting it to `C:\Program
   Files\Git\bin\bash.exe` and set the startup directory to D.
4. Download and install [Python](https://www.python.org/downloads/) **64-bit**.
   Make sure that the python version **matches** the one Vim expects. To find
   out the version, open Vim and run `:version` and look for
   `-DDYNAMIC_PYTHON3_DLL`. The number that appears on the name of the DLL is
   the python version required.
5. Clone [ctags](https://github.com/universal-ctags/ctags) and add to path.
5. Clone this repository.
6. Run `install.bat`. Make sure that it's run as **admin**.

### Vim Plugins
Once Vim is opened, everything should work as expected. If for some reason
there's an error on the command to download Vundle, simply remove the '\'
character on line 19 of `init.vim` and everything should work. Also, make sure
that Vim is first run as **admin** so permissions aren't an issue. The language
support plugins may need some extra work. 

* Python will work as is.
* C/C++ will need clang. Download the binaries from
  [here](https://releases.llvm.org/download.html) and add to path. Make sure
  that the binaries are 64-bit.
* Pandoc will require downloading it from [here](https://github.com/jgm/pandoc)
  and adding to path.

### Updating

To successfully update VIM, do the following:

1. Install the latest version of VIM.
2. Double-check the version of Python by running `:version` and looking for the
   DLL name. If the version matches the currently installed version then
   everything is fine. Otherwise, download and install the corresponding
   version.

## Linux 

Make sure that the following are installed:

1. zsh
2. neovim
3. git
4. python 3
5. clang
6. ctags
7. pandoc

Once everything is installed, just clone the repo and run `install.sh`.
Everything will be placed where it needs to be and things will just work.
