#!/usr/bin/env bash

input=$(cat)

# Parse fields using only standard tools (grep/awk/sed — no jq)
model=$(printf '%s' "$input" | awk '
    /"model"/ { in_section = 1 }
    in_section && /"display_name"/ {
        split($0, a, "\"")
        for (i = 1; i <= length(a); i++) {
            if (a[i] == "display_name") { print a[i+2]; exit }
        }
        exit
    }
')

ctx_tokens=$(printf '%s' "$input" | awk '
    /"context_window"/ { in_section = 1 }
    in_section && /"total_input_tokens"/ {
        match($0, /[0-9]+/)
        print substr($0, RSTART, RLENGTH)
        exit
    }
')

ctx_size=$(printf '%s' "$input" | awk '
    /"context_window"/ { in_section = 1 }
    in_section && /"context_window_size"/ {
        match($0, /[0-9]+/)
        print substr($0, RSTART, RLENGTH)
        exit
    }
')

ctx_used=""
if [ -n "$ctx_tokens" ] && [ -n "$ctx_size" ] && [ "$ctx_size" -gt 0 ]; then
    ctx_used=$(awk -v t="$ctx_tokens" -v s="$ctx_size" 'BEGIN { printf "%.2f", (t / s) * 100 }')
fi

five_hour=$(printf '%s' "$input" | awk '
    /"five_hour"/ { in_section = 1 }
    in_section && /"used_percentage"/ {
        match($0, /[0-9]+\.?[0-9]*/)
        print substr($0, RSTART, RLENGTH)
        exit
    }
')

# $'...' interprets escape sequences at assignment time
RESET=$'\033[0m'
BLUE=$'\033[38;2;130;170;255m'   # #82aaff
GREEN=$'\033[38;2;184;219;135m'  # #b8db87
RED=$'\033[38;2;216;105;118m'    # #d86976

# Resolve a colour name to the corresponding escape code
resolve_color() {
    case "$1" in
        blue)  printf '%s' "$BLUE" ;;
        green) printf '%s' "$GREEN" ;;
        red)   printf '%s' "$RED" ;;
    esac
}

# Context window: >80% = blue, 30-80% = green, <30% = red
ctx=""
if [ -n "$ctx_used" ]; then
    name=$(awk -v p="$ctx_used" 'BEGIN { if (p > 80) print "blue"; else if (p >= 30) print "green"; else print "red" }')
    ctx=" $(resolve_color "$name")ctx: $(printf '%.0f' "$ctx_used")% ${RESET}"
fi

# 5-hour usage: <30% = blue, 30-80% = green, >80% = red
usage=""
if [ -n "$five_hour" ]; then
    name=$(awk -v p="$five_hour" 'BEGIN { if (p < 30) print "blue"; else if (p <= 80) print "green"; else print "red" }')
    usage=" $(resolve_color "$name")5h: $(printf '%.0f' "$five_hour")% ${RESET}"
fi

printf "%s%s%s\n" "󰚩 $model " "$ctx" "$usage"
