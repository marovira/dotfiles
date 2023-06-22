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

" Disable clang_complete's key mappings for jumping to/from declaration. They don't work
" (I strongly suspect due to the lack of the .clang_complete file) and just break tag
" navigation (which is way better for my use case). I'm binding clang_jumpto_back_key to
" silence a warning because it has no mapping
let g:clang_jumpto_declaration_key = ''
let g:clang_jumpto_declaration_in_preview_key = ''
let g:clang_jumpto_back_key = '<C-q>'
