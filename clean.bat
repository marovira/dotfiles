@echo off

:: First check if we're running as admin.
echo Clean script must be run as root. Checking permissions...
net session >nul 2>&1
if %errorLevel% == 0 (
    echo Root detected.
    echo Beginning install...
) else (
    echo Error: script must be run as root. Exiting...
    exit /B
)

:: Environment variables
setx -m XDG_CONFIG_HOME ""
setx -m HOME ""

:: Neovim
rmdir %LOCALAPPDATA%\nvim
del %USERPROFILE%\.vsvimrc

:: Git
del %USERPROFILE%\.gitconfig
del %USERPROFILE%\.gitignore
del %USERPROFILE%\.gittemplate.txt

:: Language
del %USERPROFILE%\.clang-format

:: ZSH
del %USERPROFILE%\.bashrc
del %USERPROFILE%\.zshrc
del %USERPROFILE%\.zsh_plugins.txt
del %USERPROFILE%\.p10k.zsh
rmdir %USERPROFILE%\.zshfn
rmdir %APPDATA%\bat

echo Clean finished successfully
pause
