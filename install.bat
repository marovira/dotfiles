@echo off

:: First check if we're running as admin.
echo Install script must be run as root. Checking permissions...
net session >nul 2>&1
if %errorLevel% == 0 (
    echo Root detected.
    echo Beginning install...
) else (
    echo Error: script must be run as root. Exiting...
    exit /B
)

:: Grab the current directory.
set CURDIR=%~dp0

:: Set environment variables
setx HOME %USERPROFILE%
setx XDG_CONFIG_HOME %LOCALAPPDATA%

:: Setup nvim
mklink /D %LOCALAPPDATA%\nvim %CURDIR%nvim
mklink %USERPROFILE%\.vsvimrc %CURDIR%nvim\vsvim.vim

:: Now setup git
mklink %USERPROFILE%\.gitconfig %CURDIR%git\config
mklink %USERPROFILE%\.gitignore %CURDIR%git\ignore
mklink %USERPROFILE%\.gittemplate.txt %CURDIR%git\template

:: Setup language support.
mklink %USERPROFILE%\.clang-format %CURDIR%cpp\.clang-format

:: Setup ZSH
mklink %USERPROFILE%\.bashrc %CURDIR%bash\bashrc_win_zsh
mklink %USERPROFILE%\.zshrc %CURDIR%zsh\zshrc
mklink %USERPROFILE%\.zsh_plugins.txt %CURDIR%zsh\zsh_plugins
mklink %USERPROFILE%\.p10k.zsh %CURDIR%zsh\p10k.zsh
mklink /D %USERPROFILE%\.zshfn %CURDIR%zsh\zshfn
mklink /D %APPDATA%\bat %CURDIR%bat

:: Clone TPM
git clone https://github.com/tmux-plugins/tpm %USERPROFILE%\.tmux\plugins\tpm

echo Install finished successfully
pause
