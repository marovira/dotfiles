" Map clang-format to ,f
nnoremap <buffer><Leader>f :<C-u>ClangFormat<CR>

" Single-compile with clang.
nnoremap <F9> :SCCompile<CR>
nnoremap <F10> :SCCompileRun<CR>

" Auto-align settings.
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

" Settings for clang-tidy
" TODO: Ideally, it would be nice to have a config for clang-tidy, but I'm not in the mood
" to go through every single option and check to see if it's even worth it. So for now,
" just disable ALE. If at some point we come up with a .clang-tidy file that we can use
" globally, re-enable it.
let b:ale_enabled = 0
"let b:ale_linters = ['clangtidy']
"let b:ale_linters_explist = 1