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

# context_window.used_percentage is the first "used_percentage" in the JSON
# (appears before rate_limits) and is already a true 0-100 value
ctx_used=$(printf '%s' "$input" | awk '{
    if (match($0, /"used_percentage":[0-9]+\.?[0-9]*/)) {
        v = substr($0, RSTART, RLENGTH)
        match(v, /[0-9]+\.?[0-9]*/)
        print substr(v, RSTART, RLENGTH)
    }
}')

five_hour=$(printf '%s' "$input" | awk '{
    if (match($0, /"five_hour":\{[^}]*\}/)) {
        s = substr($0, RSTART, RLENGTH)
        if (match(s, /"used_percentage":[0-9]+\.?[0-9]*/)) {
            v = substr(s, RSTART, RLENGTH)
            match(v, /[0-9]+\.?[0-9]*/)
            print substr(v, RSTART, RLENGTH)
        }
    }
}')

# $'...' interprets escape sequences at assignment time
RESET=$'\033[0m'
BLUE=$'\033[38;2;130;170;255m'   # #82aaff
GREEN=$'\033[38;2;184;219;135m'  # #b8db87
RED=$'\033[38;2;216;105;118m'    # #d86976

FG_MODEL=$'\033[38;2;30;33;49m'     # #1e2131
BG_MODEL=$'\033[48;2;130;170;255m'  # #82aaff
BG_SECTION=$'\033[48;2;87;95;127m'  # #575f7f

# Separator: fg = BG_MODEL (#82aaff), bg = BG_SECTION (#575f7f)
FG_SEP=$'\033[38;2;130;170;255m'    # #82aaff
SEP1_ICON=""  # between model and ctx
SEP2_ICON=""  # between ctx and 5h usage

# Closing separator: fg = BG_SECTION (#575f7f), no bg (returns to terminal background)
FG_SEP_END=$'\033[38;2;87;95;127m'  # #575f7f

# Resolve a colour name to the corresponding escape code
resolve_color() {
    case "$1" in
        blue)  printf '%s' "$BLUE" ;;
        green) printf '%s' "$GREEN" ;;
        red)   printf '%s' "$RED" ;;
    esac
}

# Usage colour: <30% = blue, 30-80% = green, >80% = red
usage_color() {
    awk -v p="$1" 'BEGIN { if (p < 30) print "blue"; else if (p <= 80) print "green"; else print "red" }'
}

ctx=""
if [ -n "$ctx_used" ]; then
    ctx="${BG_SECTION}${FG_SEP}${SEP1_ICON}$(resolve_color "$(usage_color "$ctx_used")") ctx: $(printf '%.0f' "$ctx_used")%"
fi

usage=""
if [ -n "$five_hour" ]; then
    usage="${BG_SECTION}${FG_SEP} ${SEP2_ICON}$(resolve_color "$(usage_color "$five_hour")") 5h: $(printf '%.0f' "$five_hour")%"
fi

# Closing separator appended to whichever section is last
SEP_END="${RESET}${FG_SEP_END}${SEP1_ICON}"
if [ -n "$usage" ]; then
    usage="${usage} ${SEP_END}"
elif [ -n "$ctx" ]; then
    ctx="${ctx} ${SEP_END}"
fi

printf "%s%s%s%s\n" "${BG_MODEL}${FG_MODEL}󰚩 $model " "$ctx" "$usage" "${RESET}"
