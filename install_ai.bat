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
setx CLAUDE_CODE_GIT_BASH_PATH "%USERPROFILE%\scoop\apps\git\current\usr\bin\bash.exe"

:: Create the claude folder (if it doesn't exist)
if not exist "%USERPROFILE%\.claude\" mkdir "%USERPROFILE%\.claude"

:: Claude files
mklink %USERPROFILE%\.claude\CLAUDE.md %CURDIR%claude\CLAUDE.md
mklink %USERPROFILE%\.claude\settings.json %CURDIR%claude\settings.json
mklink %USERPROFILE%\.claude\keybindings.json %CURDIR%claude\keybindings.json
mklink /D %USERPROFILE%\.claude\skills %CURDIR%claude\skills
