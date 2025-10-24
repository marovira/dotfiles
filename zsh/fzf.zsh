function _fzf_has() {
    which "$@" > /dev/null 2>&1
}

if [[ -z "$FZF_DEFAULT_COMMAND" ]]; then
    export FZF_DEFAULT_COMMAND='find . -type f -not \( -path "*/.git/*" -o -path "./node_modules/*" \)'
    export FZF_ALT_C_COMMAND='find . -type d ( -path .git -o -path node_modules ) -prune'

    if _fzf_has rg; then
    # rg is faster than find, so use it instead.
    export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!{.git,node_modules}/**"'
    fi

    # If fd command is installed, use it instead of find
    _fzf_has 'fd' && _fd_cmd="fd"
    _fzf_has 'fdfind' && _fd_cmd="fdfind"
    if [[ -n "$_fd_cmd" ]]; then
    # Show hidden, and exclude .git and the pigsty node_modules files
    export FZF_DEFAULT_COMMAND="$_fd_cmd --hidden --follow --exclude '.git' --exclude 'node_modules'"
    export FZF_ALT_C_COMMAND="$FZF_DEFAULT_COMMAND --type d"

    _fzf_compgen_dir() {
      eval "$FZF_ALT_C_COMMAND . \"$1\""
    }

    _fzf_compgen_path() {
      eval "$FZF_DEFAULT_COMMAND . \"$1\""
    }
    fi
    unset _fd_cmd
fi

# Return one of the following preview commands:
#   - A basic foolproof preview that will rely on available tools or use fallbacks like `cat`.
#   - An advanced preview using a `less` preprocessor, capable of showing a wide range of formats, incl. images, dirs,
#     CSVs, and other binary files (depending on available tooling).
_fzf_preview() {
    _fzf_preview_pager='cat'
    foolproofPreview='cat {}'
    if _fzf_has bat; then
        _fzf_preview_pager='bat'
        foolproofPreview='([[ -f {} ]] && (bat --style=numbers --color=always {} || cat {})) || ([[ -d {} ]] && (tree -C {} | less)) || echo {} 2>/dev/null | head -n 200'
    fi
    if _fzf_has batcat; then
        _fzf_preview_pager='batcat'
        foolproofPreview='([[ -f {} ]] && (batcat --style=numbers --color=always {} || cat {})) || ([[ -d {} ]] && (tree -C {} | less)) || echo {} 2>/dev/null | head -n 200'
    fi
    local preview
    [[ "$FZF_PREVIEW_ADVANCED" == true ]] \
        && preview="lessfilter-fzf {}" \
        || preview="$foolproofPreview"
    echo "$preview"
}

export FZF_PREVIEW="$(_fzf_preview)"
export FZF_PREVIEW_WINDOW=":hidden"
export FZF_COLOR_SCHEME="--color=border:#589ed7 \
    --color=fg:#c8d3f5 \
    --color=gutter:#1e2030 \
    --color=header:#ff966c \
    --color=hl+:#65bcff \
    --color=hl:#65bcff \
    --color=info:#545c7e \
    --color=marker:#c3e88d \
    --color=pointer:#ff007c \
    --color=prompt:#65bcff \
    --color=query:#c8d3f5:regular \
    --color=scrollbar:#589ed7 \
    --color=separator:#ff966c \
    --color=spinner:#ff007c \
"

export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS \
    --layout=reverse \
    --info=inline-right \
    --multi \
    --preview='${FZF_PREVIEW}' \
    --preview-window='${FZF_PREVIEW_WINDOW}' \
    --highlight-line \
    --border=none \
    ${FZF_COLOR_SCHEME} \
    --marker=✓ \
    --pointer=▶ \
    --bind '?:toggle-preview' \
    --bind 'ctrl-a:select-all' \
"
export FZF_CTRL_T_COMMAND="${FZF_DEFAULT_COMMAND}"
eval "$(fzf --zsh)"

unset -f _fzf_has
unset -f _fzf_preview
