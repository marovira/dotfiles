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

:: Setup language support.
mklink %USERPROFILE%\.clang-format %CURDIR%cpp\.clang-format
mklink %USERPROFILE%\pylintrc %CURDIR%python\pylintrc

:: Create an alias for python3 in the currently installed Python directory.
set PYTHON_ROOT=
for /F %%I in ('where python') do set "PYTHON_ROOT=%%~dpI"
mklink %PYTHON_ROOT%\python3.exe %PYTHON_ROOT%\python.exe

:: Finally, setup the bashrc.
mklink %USERPROFILE%\.bashrc %CURDIR%bash\bashrc

echo Install finished successfully
