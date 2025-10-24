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
setx XDG_CONFIG_HOME ""
setx XDG_DATA_HOME ""
setx XDG_CACHE_HOME ""

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
del %USERPROFILE%\.zshenv
rmdir %USERPROFILE%\.config\zsh

:: Bat
del %USERPROFILE%\scoop\apps\bat\current\config
del %USERPROFILE%\scoop\apps\bat\themes\tokyonight_moon.tmTheme

:: Wezterm
rmdir %LOCALAPPDATA%\wezterm

echo Clean finished successfully
pause
