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
setx HOME %USERPROFILE%
setx PATH "%PATH%;%USERPROFILE%\scoop\apps\git\current\bin"

:: Make sure the .config folder exists
if not exist "%USERPROFILE%\.config\" mkdir %USERPROFILE%\.config

:: nvim
mklink /D %LOCALAPPDATA%\nvim %CURDIR%nvim
mklink %USERPROFILE%\.vsvimrc %CURDIR%nvim\vsvim.vim

:: git
mklink %USERPROFILE%\.gitconfig %CURDIR%git\config
mklink %USERPROFILE%\.gitignore %CURDIR%git\ignore

:: zsh
mklink %USERPROFILE%\.bashrc %CURDIR%bash\bashrc_win_zsh
mklink %USERPROFILE%\.zshenv %CURDIR%zsh\zshenv
mklink /D %USERPROFILE%\.config\zsh %CURDIR%zsh

:: bat
mklink %USERPROFILE%\scoop\apps\bat\current\config %CURDIR%bat\config
mklink %USERPROFILE%\scoop\apps\bat\current\themes\tokyonight_moon.tmTheme %CURDIR%bat\themes\tokyonight_moon.tmTheme

:: wezterm
mklink /D %LOCALAPPDATA%\wezterm %CURDIR%wezterm

echo Install finished successfully
pause
