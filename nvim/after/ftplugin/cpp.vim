" Single-compile
nnoremap <F9> :SCCompile<CR>
nnoremap <F10> :SCCompileRun<CR>

" Disable linting, but keep clang-format
let b:ale_linters = []
let b:ale_fixers = ['clang-format']
let b:ale_linters_explicit = 1
