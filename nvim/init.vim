" vim-plug setup.
"=======================
if has('win32')
    let s:editorRoot=expand($XDG_CONFIG_HOME . '\nvim')
elseif has('nvim')
    let s:editorRoot=expand('~/.config/nvim')
endif

let plugInstalled = 1
let plugSrc = s:editorRoot . '/autoload/plug.vim'
if !filereadable(plugSrc)
    echo 'Installing vim-plug'
    echo ''
    call mkdir(s:editorRoot . '/autoload/', 'p')
    execute '!curl -fLo ' . s:editorRoot . '/autoload/plug.vim https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    let plugInstalled = 0
endif

call plug#begin()
" LSP + autocomplete
"=======================
" LSP
Plug 'williamboman/mason.nvim', {'do': ':MasonUpdate'}
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'neovim/nvim-lspconfig'

" Auto-complete
Plug 'lifepillar/vim-mucomplete'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-nvim-lsp-signature-help'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-buffer'
Plug 'L3MON4D3/LuaSnip'

" Handle LSP setup
Plug 'VonHeikemen/lsp-zero.nvim', {'branch': 'v2.x'}

" Syntax highlighting
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" Telescope
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.2' }
Plug 'natecraddock/telescope-zf-native.nvim'
Plug 'nvim-telescope/telescope-file-browser.nvim'


" Undo tree.
Plug 'mbbill/undotree'

" TMUX integration
Plug 'christoomey/vim-tmux-navigator'

" Colour schemes
"=======================
" Dark theme
Plug 'dracula/vim'

" IDE-like plugins
"=======================
" Tree explorer for Vim.
Plug 'nvim-tree/nvim-web-devicons'
Plug 'nvim-tree/nvim-tree.lua'

" Commenter for all code!
Plug 'preservim/nerdcommenter'

" Fast folding
Plug 'Konfekt/FastFold'

" Better statusline
Plug 'itchyny/lightline.vim'
Plug 'itchyny/vim-gitbranch'
Plug 'maximbaz/lightline-ale'

" Indentation guides.
Plug 'preservim/vim-indent-guides'

" Autocomplete pairs.
Plug 'Raimondi/delimitMate'

" Language support
"=======================
" LaTeX support.
Plug 'lervag/vimtex'

" Pandoc.
Plug 'vim-pandoc/vim-pandoc'
Plug 'vim-pandoc/vim-pandoc-syntax'

" Linting + formatting
Plug 'dense-analysis/ale'

" Checkbox toggle for markdown.
Plug 'jkramer/vim-checkbox'

" Simple compile for C++ (Windows only).
if has('win32')
    Plug 'xuhdev/SingleCompile'
endif

" Miscellaneous
"=======================
" Better startup screen
Plug 'mhinz/vim-startify'

call plug#end()

if plugInstalled == 0
    echo 'Installing plugins'
    echo ''
    :PlugInstall
endif

" Functions
"=======================
let s:numberMode = 0
function ToggleNumbers()
    if s:numberMode
        set nu rnu
        let s:numberMode = 0
    else
        set nu nornu
        let s:numberMode = 1
    endif
endfunction

function SetStateForLargeFiles()
    setlocal bufhidden=unload       " Save memory when other file is viewed
    setlocal buftype=nowrite        " Is read-only
    setlocal eventignore+=FileType  " Ignore autocommands with FileType as their triggers
    setlocal undolevels=-1          " No undo
    setlocal nofoldenable           " Disable folding
    MUcompleteAutoOff               " Disable Mu-complete
endfunction

" Options
"=======================
lua require("options")

" Plug-in Settings
"=======================
" Lua-enabled plugins go first.
lua require('plugins')

" Global linting options
let g:ale_fixers = {
            \ '*': ['remove_trailing_lines', 'trim_whitespace']
            \}
let g:ale_set_loclist = 0
let g:ale_set_quickfix = 0
let g:ale_use_neovim_diagnostics_api = 1
let g:ale_open_list = 1
let g:ale_fix_on_save = 1

" Mucomplete
let g:mucomplete#enable_auto_at_startup = 1

" delimitMate
let g:delimitMate_expand_cr = 2
let g:delimitMate_expand_space = 1

" Pandoc
let g:pandoc#command#autoexec_command = "Pandoc! pdf"
let g:pandoc#command#latex_engine = "pdflatex"
let g:pandoc#formatting#mode = "h"
let g:pandoc#formatting#textwidth = &tw
let g:pandoc#modules#disabled = ['folding']

" Single compile
if has('win32') || has('win64')
    call SingleCompile#SetCompilerTemplate('cpp', 'clang-cl', 'Windows Clang', 'clang-cl', '/std:c++20 /EHsc /Od /W3 -o $(FILE_TITLE)$', '$(FILE_TITLE)$')
    call SingleCompile#SetOutfile('cpp', 'clang-cl', '$(FILE_TITLE)$.exe')

    let g:SingleCompile_alwayscompile = 0
    let g:SingleCompile_showquickfixiferror = 1
    let g:SingleCompile_showquickfixifwarning = 1
    let g:SingleCompile_showresultafterrun = 1
endif

" Checkbox
let g:insert_checkbox = '\<'
let g:insert_checkbox_prefix = ''
let g:insert_checkbox_suffix = ' '

" FastFold
let g:fastfold_savehook = 1
let g:markdown_folding = 1
let g:tex_fold_enabled = 1

fun! GetMUCompleteStatus()
  return get(g:mucomplete#msg#short_methods,
    \        get(g:, 'mucomplete_current_method', ''), '')
endf

" Lightline
let g:lightline = {
    \ 'colorscheme': 'darcula',
    \ 'active': {
        \ 'left': [ [ 'mode', 'paste' ],
        \           [ 'readonly', 'git_branch' ,'filename', 'modified' ] ],
        \ 'right': [ ['linter_checking', 'linter_errors', 'linter_warnings', 'linter_infos', 'linter_hits', 'linter_ok'],
        \            ['lineinfo'],
        \            [ 'percent' ],
        \            [ 'fileformat', 'fileencoding', 'filetype' ] ],
    \ },
    \ 'component_expand': {
        \ 'linter_checking': 'lightline#ale#checking',
        \ 'linter_infos': 'lightline#ale#infos',
        \ 'linter_warnings': 'lightline#ale#warnings',
        \ 'linter_errors': 'lightline#ale#errors',
        \ 'linter-ok': 'lightline#ale#ok',
    \ },
    \ 'component_function': {
        \ 'git_branch': 'gitbranch#name',
        \ 'mu_status': 'GetMUCompleteStatus',
    \ },
\ }

" Autocommands
"=======================
lua require("autocmd")

" Key remaps
"=======================
lua require("maps")
