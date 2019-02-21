# Dotfiles

The source of all my config files. Below is a (partial) set of instructions for
installing depending on the OS.

## Windows
### Setup
1. First download Vim (8+) 32-bit and install it to the root of C. **DO NOT**
   install to the default location! The spaces cause problems later on, so just
install to `C:\Vim`. Also make sure that there is no default vimrc or vimfiles
directory.
2. Download and install git and git bash. Make sure that everything is added to
   the path.
3. Download and install ConsoleZ. Add git bash by creating a new tab and setting
   it to `C:\Program Files\Git\bin\bash.exe` and set the startup directory to D.
4. Download and install Python3 32-bit version.
5. Clone ctags from [here](https://github.com/universal-ctags/ctags) and add to
   path.
4. Clone the repository.

### Links
To make life easier, we are going to make links for all git and vim files. This
is accomplished with a command line (in **admin** mode) and using

```bat
mklink link target
mklink /D linkDir targetDir
```

to connect everything. Make sure that all git files (and the bashrc) go into
`C:\Users\<username>` while the vim files go in the Vim directory `C:\Vim`

### Vim Plugins
Once Vim is opened, everything should work as expected. If for some reason
there's an error on the command to download Vundle, simply remove the '\'
character on line 19 of 'init.vim' and everything should work. Also, make sure
that Vim is first run as **admin** so permissions aren't an issue. The language
support plugins may need some extra work. 

* For Java, make sure that the JDK is installed and added to the path.
* Python will work as is.
* C/C++ will need clang. Follow the instructions
  [here](https://clang.llvm.org/get_started.html) to compile Clang with Visual
Studio. Make sure that the build is **32-bit**. Once everything is compiled,
just add the directory to the path and everything will work correctly.
* Pandoc will require downloading it from [here](https://github.com/jgm/pandoc)
  and adding to path.

## Linux Make sure that the following are installed:

1. zsh
2. neovim
3. git
4. python 3
5. clang
6. ctags
7. pandoc

Once everything is installed, just clone the repo and run `install.sh`.
Everything will be placed where it needs to be and things will just work.
