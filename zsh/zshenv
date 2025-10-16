# Ensure XDG directories are always consistent
_cur_os=$(uname)
if [[ "$_cur_os" == "Darwin" || "$cur_os" == "Linux" ]]; then
    export XDG_CONFIG_HOME="$HOME/.config"
    export XDG_DATA_HOME="$HOME/.local/share"
    export XDG_STATE_HOME="$HOME/.local/state"
    export XDG_CACHE_HOME="$HOME/.cache"
fi
unset -v _cur_os

export EDITOR="nvim"
export LS_COLORS="$LS_COLORS:ow=1;34:tw=1;34:"

# Source cargo (if available).
if [ -f "$HOME/.cargo/env" ]; then
    . "$HOME/.cargo/env"
fi
