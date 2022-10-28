" Disable all linters except for pylint.
let b:ale_linters = ['pylint']
let b:ale_fixers = ['remove_trailing_lines', 'trim_whitespace', 'black']
let b:ale_linters_explicit = 1
let b:ale_lint_on_text_changed = 0
let b:ale_lint_on_save = 1
let b:ale_lint_on_enter = 1

" Easier navigation of linter errors:
nnoremap <localleader>lp <Plug>(ale_previous_wrap)
nnoremap <localleader>ln <Plug>(ale_next_wrap)

" Disable MuComplete and switch to NCM2
MUcompleteAutoOff
call ncm2#enable_for_buffer()

" Set the key bindings for ncm2.
inoremap <c-c> <ESC>
inoremap <expr> <CR> (pumvisible() ? "\<c-y>\<cr>" : "\<CR>")
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

