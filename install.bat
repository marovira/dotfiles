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

:: First setup nvim
setx -m XDG_CONFIG_HOME %LOCALAPPDATA%
mklink /D %LOCALAPPDATA%\nvim %CURDIR%nvim
mklink %USERPROFILE%\.vsvimrc %CURDIR%nvim\vsvim.vim

:: Now setup the git stuff
mklink %USERPROFILE%\.gitconfig %CURDIR%git\config
mklink %USERPROFILE%\.gitignore %CURDIR%git\ignore
mklink %USERPROFILE%\.gittemplate.txt %CURDIR%git\template

:: Setup language support.
mklink %USERPROFILE%\.clang-format %CURDIR%cpp\.clang-format
mklink %USERPROFILE%\.pylintrc %CURDIR%python\pylintrc

:: Finally, setup zsh
mklink %USERPROFILE%\.bashrc %CURDIR%bash\bashrc_win_zsh
mklink %USERPROFILE%\.zshrc %CURDIR%zsh\zshrc
mklink %USERPROFILE%\.zsh_plugins.txt %CURDIR%zsh\zsh_plugins_win
mklink %USERPROFILE%\.p10k.zsh %CURDIR%zsh\p10k.zsh
mklink /D %USERPROFILE%\.zshfn %CURDIR%zsh\zshfn

echo Install finished successfully
