# Ensure XDG directories are always consistent
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
export XDG_CACHE_HOME="${$XDG_CACHE_HOME:-$HOME/.cache}"

export EDITOR="nvim"
export LS_COLORS="$LS_COLORS:ow=1;34:tw=1;34:"

# Source cargo (if available).
if [ -f "$HOME/.cargo/env" ]; then
    . "$HOME/.cargo/env"
fi
