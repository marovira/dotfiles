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

" Bar with tags.
Plug 'preservim/tagbar'

" GLSL syntax highlighting.
Plug 'tikhomirov/vim-glsl'

" Commenter for all code!
Plug 'preservim/nerdcommenter'

" Fast folding
Plug 'Konfekt/FastFold'

" Better statusline
Plug 'itchyny/lightline.vim'
Plug 'itchyny/vim-gitbranch'
Plug 'josa42/nvim-lightline-lsp'

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

" Linting
Plug 'mfussenegger/nvim-lint'

" Formatting
Plug 'mhartington/formatter.nvim'

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

function StripTrailingWhitespace()
    let l:savepos = winsaveview()
    %s/\s\+$//e
    call winrestview(l:savepos)
endfunction

" Only enable nvim-cmp on specific buffers:
" Python, C++, Lua
function ShouldLSPBeEnabled()
    if &ft == 'python' || &ft == 'cpp' || &ft == 'lua'
        return 1
    else
        return 0
    endif
endfunction

function EnterBuffer(enter)
    if a:enter && ShouldLSPBeEnabled()
        execute 'MUcompleteAutoOff'
        lua Enable_cmp(true)
    else
        lua Enable_cmp(false)
        execute 'MUcompleteAutoOn'
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
set autoread                    " Automatically re-read file
set backspace=start,indent,eol  " Backspace works on everything
set cmdheight=2                 " More space for the command bar
set confirm	                    " Save files on exit
set cursorline	                " Show current cursor line
set foldmethod=syntax           " Use syntax definitions for folding
set hidden 	                    " Don't have to save when changing buffers
set hlsearch	                " Highlights search
set incsearch                   " Incremental search
set infercase	                " Adjust case of match for keyword completion
set laststatus=2                " Always show status bar
set lazyredraw	                " Only redraws what is necessary, when necessary :redraw to force
set modeline	                " Enable top-of-file modelines NOTE: security concerns with these
set mouse=a	                    " Enable Mouse Clicks
set mousefocus	                " Focus follows mouse
set mousehide	                " Hides pointer while typing
set nostartofline               " Don't move cusor on line jumps
set ruler	                    " Show column and character in file
set spell 	                    " Spelling
set spelllang=en_gb             " Use GB English
set tw=90 	                    " Text Width
set wildmenu                    " Auto completion in commandline
set completeopt=menuone,noselect,noinsert
set shortmess+=ac                " Turn off completion messages.
set belloff+=ctrlg              " If Vim beeps during completion.
set number relativenumber       " Set hybrid line numbers

" File format settings.
set encoding=utf-8
set fileformat=unix
set fileformats=unix,dos

" Tab settings
set tabstop=4 softtabstop=4 shiftwidth=4 expandtab

" Syntax and file detection.
filetype plugin indent on
syntax on

" Map leader and localleader to ,
let mapleader = ","
let maplocalleader = ","

let g:dracula_colorterm = 0
colorscheme dracula
let &colorcolumn=join(range(&tw,&tw), ",")

" Copy to system clipboard (this only works on windows and mac)
if has("win32") || has("mac")
    set clipboard=unnamed
endif

" Plug-in Settings
"=======================
" Lua-enabled plugins go first.
lua require('lsp')
lua require('plugins')

" Undotree
if has("persistent_undo")
    set undodir=~/.undodir/
    set undofile
endif

" Mucomplete
let g:mucomplete#enable_auto_at_startup = 1

" NCM2
if has('win32')
    " Windows doesn't use the python3 convention for the exe name, so just set it to
    " python directly.
    let g:python3_host_prog = 'python'
else
    " Use a specific virtual environment for nvim so we don't have to install pynvim
    " everywhere.
    let g:python3_host_prog = '~/nvim/bin/python3'
endif

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
        \ 'linter_checking': 'lsp_status',
        \ 'linter_infos': 'lsp_info',
        \ 'linter_hints': 'lsp_hints',
        \ 'linter_warnings': 'lsp_warnings',
        \ 'linter_errors': 'lsp_errors',
        \ 'linter_ok': 'lsp_ok',
    \ },
    \ 'component_function': {
        \ 'git_branch': 'gitbranch#name',
        \ 'mu_status': 'GetMUCompleteStatus',
    \ },
\ }

" Autocommands
"=======================
let g:large_file = 1024 * 1024 * 100 " Large is defined > 100 MB
augroup ma
    autocmd!

    " Treat C files as C++. In the event we ever write C again, change this.
    autocmd BufRead,BufNewFile *.h,*.c set filetype=cpp

    " If we're entering/leaving from a buffer that should ONLY use LSP, make sure that
    " Mucomplete gets disabled.
    autocmd BufEnter * call EnterBuffer(1)
    autocmd BufLeave * call EnterBuffer(0)

    autocmd BufWritePost *.py lua require('lint').try_lint()

    " Buffer behaviour
    autocmd InsertEnter * silent! :set nornu number
    autocmd InsertLeave,BufNewFile,VimEnter * silent! :set rnu number
    autocmd BufRead,BufNewFile *.json silent! :set nofoldenable
    autocmd BufReadPre * let f=expand("<afile>") | if getfsize(f) > g:large_file | :call SetStateForLargeFiles() | endif
    autocmd BufWritePost * FormatWriteLock

    " Syntax
    autocmd Syntax * call matchadd('Todo', '\W\zs\(TODO\|FIXME\|CHANGED\|XXX\|BUG\|HACK\)')
    autocmd Syntax * call matchadd('Debug', '\W\zs\(NOTE\|INFO\|IDEA\)')
augroup end

" Key remaps
"=======================
" Paste options.
nnoremap <F2> :set invpaste paste?<CR>
imap <F2> <C-O>:set invpaste paste?<CR>
set pastetoggle=<F2>

" Toggle numbers.
nnoremap <C-n> :call ToggleNumbers()<CR>

" Clear search highlight.
nnoremap <silent> <ESC> :noh<CR><ESC>

" Remap esc to jk.
inoremap jk <ESC>

" Buffer navigation.
nnoremap <C-h> <C-w>h
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <C-j> <C-w>j

" Play macro stored in buffer q with the space bar
nnoremap <Space> @q

" IDE-like settings.
nmap <F5> :UndotreeToggle<CR>
nmap <F7> :NvimTreeToggle<CR>
nmap <F8> :TagbarToggle<CR>
nmap <silent> <leader>f :Format<CR>
nmap <silent> <leader>F :FormatWrite<CR>
