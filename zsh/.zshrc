HISTFILE=${ZDOTDIR}/.zsh_history
setopt EXTENDED_HISTORY
setopt inc_append_history_time

# Setup platform identification
_uname=$(uname)
case "$_uname" in
    "Linux") _current_platform="Linux";;
    "Darwin") _current_platform="Darwin";;
    "CYGWIN"*) _current_platform="Windows";;
    "MINGW"*) _current_platform="Windows";;
    "MSYS"*) _current_platform="Windows";;
    "GNU"*) _current_platform="Linux";;
    *) printf "%s\n" "Unknown OS found: $_uname"; exit 1;;
esac

_has_brew=false
if [[ "$_current_platform" == "Darwin" ]]; then
    if command -v brew > /dev/null 2>&1; then
        _has_brew=true
    fi
fi

_has_brew_python3=false
if $_has_brew; then
    # Check every possible version of Python we know of.
    if brew ls --versions python@3.12 > /dev/null; then
        _has_brew_python3=true
    elif brew ls --versions python@3.13 > /dev/null; then
        _has_brew_python3=true
    fi
fi

_is_linux() {
    [[ "$_uname" == "Linux" ]]
}

# On Windows, ensure that zshenv and zprofile are manually loaded. Also unset SHELL as
# this causes issues with other commands.
if [[ "$_current_platform" == "Windows" ]]; then
    unset SHELL
fi

# Load compinit for Windows and macOS since they don't enable it by default
if [[ "$_current_platform" == "Windows" || "$_current_platform" == "Darwin" ]]; then
    autoload -Uz compinit
    compinit
fi

# Install antidote if necessary
ANTIDOTE=${ZDOTDIR}/.antidote
if [ ! -d $ANTIDOTE ]; then
    echo "Downloading antidote"
    git clone --depth=1 https://github.com/mattmc3/antidote.git $ANTIDOTE
fi

source $ANTIDOTE/antidote.zsh
antidote load

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Alias NeoVim to Vim
if command -v nvim > /dev/null 2>&1; then
    alias vi='nvim'
    alias vim='nvim'
fi

# On Windows only, override neovide so it opens with the size we want. Also it seems the
# latest version of Neovide has an issue with forking correctly on git bash, so ensure it
# doesn't block the terminal when started.
if [[ "$_current_platform" == "Windows" ]]; then
    alias neovide='(neovide --grid 100x50 &)'
fi

# On macOS only, ensure that python3 gets overwritten to the location of the version we
# install with homebrew.
if $_has_brew && $_has_brew_python3; then
    alias python3=/opt/homebrew/bin/python3
fi

# Grep aliases
alias grep='grep --color'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

# Better history
if command -v bat > /dev/null 2>&1; then
    alias history='fc -rli 1 | bat -n -l zsh'
else
    alias history='fc -rli 1 | less'
fi

# Emulates Apple's open. Only applies to Linux (linux-gnu) and Windows (msys).
if [[ "$_current_platform" == "Linux" ]]; then
    alias open='xdg-open'
elif [[ "$_current_platform" == "Windows" ]]; then
    alias open='start'
fi

# Allow Windows to open bash without any settings. This is mainly to address an issue
# where certain paths don't work in zsh.
if [[ "$_current_platform" == "Windows" ]]; then
    alias bash='bash --norc --noprofile'
fi

# Director listings.
alias ls='ls -1 -hF --color=auto'
alias la='ls -A'

# rsync alias
alias rsync='rsync -aP'

bindkey '^[[Z' autosuggest-accept

# Automatically load all zshfn files.
fpath+=(${ZDOTDIR}/zshfn)
autoload -U $fpath[-1]/*(.:t)

# Add forgit to path for completions
fpath+=($FORGIT_INSTALL_DIR/completions/_git-forgit)
autoload -U $FORGIT_INSTALL_DIR/completions/_git-forgit

# Add UV completions (if it exists)
if type "uv" > /dev/null; then
    eval "$(uv generate-shell-completion zsh)"
    eval "$(uvx --generate-shell-completion zsh)"

    # Fix completions for uv run.
    _uv_run_mod() {
        if [[ "$words[2]" == "run" && "$words[CURRENT]" != -* ]]; then
            _arguments '*:filename:_files'
        else
            _uv "$@"
        fi
    }
    compdef _uv_run_mod uv
fi

PATH="$PATH:$FORGIT_INSTALL_DIR/bin"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ${ZDOTDIR}/.p10k.zsh ]] || source ${ZDOTDIR}/.p10k.zsh

if [[ "$_current_platform" == "Windows" ]]; then
    keep_current_path() {
        printf "\033]7;file//$HOST/$PWD\033\\"
    }
    precmd_functions+=(keep_current_path)
fi

unset -v _uname
unset -v _has_brew
unset -v _has_brew_python3
unset -v _current_platform
unset -v _is_linux
