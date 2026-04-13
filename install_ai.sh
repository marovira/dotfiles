#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

source "$SCRIPT_DIR/common.sh"

# Ensure that .claude exists
mkdir -p "$HOME/.claude"

mklink "$SCRIPT_DIR/claude/CLAUDE.md" "$HOME/.claude/CLAUDE.md"
mklink "$SCRIPT_DIR/claude/settings.json" "$HOME/.claude/settings.json"
mklink "$SCRIPT_DIR/claude/keybindings.json" "$HOME/.claude/keybindings.json"
mklink "$SCRIPT_DIR/claude/skills" "$HOME/.claude/skills"
