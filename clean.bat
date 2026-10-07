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
reg delete "HKCU\Environment" /v XDG_CONFIG_HOME /f >nul 2>&1
reg delete "HKCU\Environment" /v HOME /f >nul 2>&1
reg delete "HKCU\Environment" /v CLAUDE_CODE_GIT_BASH_PATH /f >nul 2>&1

:: Neovim
rmdir %LOCALAPPDATA%\nvim
del %USERPROFILE%\.vsvimrc

:: Git
del %USERPROFILE%\.gitconfig
del %USERPROFILE%\.gitignore

:: Language
if exist %USERPROFILE%\.clang-format del %USERPROFILE%\.clang-format

:: ZSH
del %USERPROFILE%\.bashrc
del %USERPROFILE%\.zshenv
rmdir %USERPROFILE%\.config\zsh
rmdir %USERPROFILE%\.config\zsh-patina

:: Bat
del %USERPROFILE%\scoop\apps\bat\current\config
del %USERPROFILE%\scoop\apps\bat\current\themes\tokyonight_moon.tmTheme
del %USERPROFILE%\scoop\apps\bat\current\themes\tokyonight_moon_tree.tmTheme
del %USERPROFILE%\scoop\apps\bat\current\syntaxes\tree.sublime-syntax

:: Wezterm
rmdir %LOCALAPPDATA%\wezterm

del %USERPROFILE%\.claude\CLAUDE.md
del %USERPROFILE%\.claude\settings.json
del %USERPROFILE%\.claude\keybindings.json
del %USERPROFILE%\.claude\statusline.sh
rmdir %USERPROFILE%\.claude\skills

echo Clean finished successfully
pause
