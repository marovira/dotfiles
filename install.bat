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
setx -m VIM "C:\Vim"

:: First setup the vim shortcuts.
mklink %VIM%\_vimrc %CURDIR%nvim\init.vim
mklink %VIM%\_gvimrc %CURDIR%nvim\gvim.vim
mklink %VIM%\_vsvimrc %CURDIR%nvim\vsvim.vim
mklink /D %VIM%\vimfiles\after %CURDIR%nvim\after

:: Now setup the git stuff
mklink %USERPROFILE%\.gitconfig %CURDIR%git\config
mklink %USERPROFILE%\.gitignore %CURDIR%git\ignore
mklink %USERPROFILE%\.gittemplate.txt %CURDIR%git\template

:: Finally, setup the bashrc.
mklink %USERPROFILE%\.bashrc %CURDIR%bash\bashrc

echo Install finished successfully
