" Map clang-format to ,f
nnoremap <buffer><Leader>f :<C-u>ClangFormat<CR>

" Single-compile with clang.
nnoremap <F9> :SCCompile<CR>
nnoremap <F10> :SCCompileRun<CR>

" Auto-align settings.
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)
