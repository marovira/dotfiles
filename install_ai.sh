#!/bin/bash


mklink() {
    ln -sf "$1" "$2"
}

# Ensure that .claude exists
mkdir -p "$HOME/.claude"

mklink "$PWD/claude/CLAUDE.md" "$HOME/.claude/CLAUDE.md"
mklink "$PWD/claude/settings.json" "$HOME/.claude/settings.json"
mklink "$PWD/claude/keybindings.json" "$HOME/.claude/keybindings.json"
mklink "$PWD/claude/skills" "$HOME/.claude/skills"
