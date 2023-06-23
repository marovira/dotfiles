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

:: Set the Vim environment variable.
REM setx -m VIM "C:\Vim"

:: First setup the vim shortcuts.
REM mklink %VIM%\_vimrc %CURDIR%nvim\init.vim
REM mklink %VIM%\_gvimrc %CURDIR%nvim\gvim.vim
REM mklink %VIM%\_vsvimrc %CURDIR%nvim\vsvim.vim
REM mklink /D %VIM%\vimfiles\after %CURDIR%nvim\after

:: NVim shortcuts
setx -m XDG_CONFIG_HOME %LOCALAPPDATA%
mkdir %LOCALAPPDATA%\nvim
mklink %LOCALAPPDATA%\nvim\init.vim %CURDIR%nvim\init.vim
mklink %LOCALAPPDATA%\nvim\gvim.vim %CURDIR%nvim\ginit.vim
mklink /D %LOCALAPPDATA%\nvim\after %CURDIR%nvim\after


:: Now setup the git stuff
mklink %USERPROFILE%\.gitconfig %CURDIR%git\config
mklink %USERPROFILE%\.gitignore %CURDIR%git\ignore
mklink %USERPROFILE%\.gittemplate.txt %CURDIR%git\template

:: Setup language support.
mklink %USERPROFILE%\.clang-format %CURDIR%cpp\.clang-format
mklink %USERPROFILE%\pylintrc %CURDIR%python\pylintrc

:: Finally, setup the bashrc.
mklink %USERPROFILE%\.bashrc %CURDIR%bash\bashrc

echo Install finished successfully
