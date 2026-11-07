#!/usr/bin/env bash
#
# PreCompact hook. Whatever this prints to stdout is used by Claude Code as
# instructions for the compaction summary.
#
# The hook input is JSON on stdin. `custom_instructions` holds the argument given to
# `/compact`, and is null for a bare `/compact` and for auto-compaction.

# What to do when `/compact <instructions>` is used:
#   replace - print only the custom instructions (the default list is skipped)
#   append  - print the default list followed by the custom instructions
MODE=append

default_instructions() {
    cat <<'EOF'
When summarizing, preserve:
- The files modified this session and why.
- The exact text of failing test, build, and lint errors.
- Decisions made and their reasons, including approaches tried and rejected.
- The commands that worked for building, testing, and linting.
- Where the commit workflow stands (work awaiting approval, files already staged).
- Corrections and preferences the user stated during the session.
- Open TODOs.

Drop file contents that can be re-read, verbose tool output, and exploration that led nowhere.
EOF
}

# Without jq the custom instructions cannot be read, so fall back to the defaults.
if ! command -v jq > /dev/null 2>&1; then
    default_instructions
    exit 0
fi

# Null, missing, and whitespace-only values all become an empty string.
custom=$(jq -r '(.custom_instructions // "") | gsub("^[[:space:]]+|[[:space:]]+$"; "")')

if [ -z "$custom" ]; then
    default_instructions
elif [ "$MODE" = "append" ]; then
    default_instructions
    printf '\nAdditional focus requested by the user:\n%s\n' "$custom"
else
    printf '%s\n' "$custom"
fi
