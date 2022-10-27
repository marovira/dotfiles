" Reduce indentation to 2 spaces
setlocal tabstop=2
setlocal shiftwidth=2
setlocal softtabstop=2
setlocal expandtab

" Plugins
"=======================
" Vimtex
let b:vimtex_indent_ignored_envs = []
let b:vimtex_fold_enabled = 0
let b:vimtex_view_method = 'general'
let b:vimtex_view_general_viewer = 'SumatraPDF'
let b:vimtex_view_general_options = '-reuse-instance -forward-search @tex @line @pdf'
let g:vimtex_include_search_enabled = 0

" ALE
let b:ale_enabled = 0

" Make vimtex stop continuous compile before cleaning
nnoremap <localleader>lc :VimtexStop<cr>:VimtexClean<cr>

" Make Vimtex clean everything when we close the file.
augroup vimtex_config
    au!
    au User VimtexEventQuit call vimtex#compiler#clean(0)
augroup END

