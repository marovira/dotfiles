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
mklink %USERPROFILE%\.zprofile %CURDIR%zsh\zprofile
mklink %USERPROFILE%\.zshenv %CURDIR%zsh\zshenv
mklink %USERPROFILE%\.zsh_plugins.txt %CURDIR%zsh\zsh_plugins
mklink %USERPROFILE%\.p10k.zsh %CURDIR%zsh\p10k.zsh
mklink /D %USERPROFILE%\.zshfn %CURDIR%zsh\zshfn
mklink /D %USERPROFILE%\.zshpy %CURDIR%zsh\zshpy

:: Setup bat
mklink %USERPROFILE%\scoop\apps\bat\current\config %CURDIR%bat\config
mklink %USERPROFILE%\scoop\apps\bat\current\themes\tokyonight_moon.tmTheme %CURDIR%bat\themes\tokyonight_moon.tmTheme

:: Setup Wezterm
mklink /D %LOCALAPPDATA%\wezterm %CURDIR%wezterm

echo Install finished successfully
pause
