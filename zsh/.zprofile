export PATH="$HOME/.local/bin:$PATH"
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"

export COLUMNS
export FZF_PREVIEW_COLUMNS

export FORGIT_FZF_DEFAULT_OPTS="--preview-window=right:60%"
export FORGIT_NO_ALIASES=1

_cur_os=$(uname)
if [[ "$_cur_os" == "Darwin" ]]; then
    if command -v brew > /dev/null 2>&1 && brew ls --versions llvm > /dev/null; then
        export PATH="/opt/homebrew/opt/llvm/bin:$PATH"
        export CC="/opt/homebrew/opt/llvm/bin/clang"
        export CXX="/opt/homebrew/opt/llvm/bin/clang++"
        export LDFLAGS="$LDFLAGS -L/opt/homebrew/opt/llvm/lib"
        export CPPFLAGS="$CPPFLAGS -I/opt/homebrew/opt/llvm/include"
    fi
fi
unset -v _cur_os
