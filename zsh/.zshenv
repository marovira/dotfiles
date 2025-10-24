# Ensure XDG directories are always consistent
_cur_os=$(uname)
if [[ "$_cur_os" == "Linux" || "$_cur_os" == "Darwin" ]]; then
    export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
    export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
    export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
    export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
fi
unset -v _cur_os

export EDITOR="nvim"
export LS_COLORS="$LS_COLORS:ow=1;34:tw=1;34:"
