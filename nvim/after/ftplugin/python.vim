" Disable all linters except for pylint.
let b:ale_linters = ['pylint']
let b:ale_linters_explicit = 1

" Easier navigation of linter errors:
nnoremap <localleader>lp <Plug>(ale_previous_wrap)
nnoremap <localleader>ln <Plug>(ale_next_wrap)
