" Vundle setup.
"=======================
" Set the path of the editor.
if has('win32')
    let s:editorRoot=$VIM . '\vimfiles'
elseif has('nvim')
    let s:editorRoot=expand('~/.config/nvim')
endif

let vundleInstalled=1
let vundleReadme=s:editorRoot . '/bundle/Vundle.vim/README.md'
if !filereadable(vundleReadme)
    echo 'Installing Vundle'
    echo ''
    call mkdir(s:editorRoot . '/bundle/', 'p')
    execute '!git clone https://github.com/VundleVim/Vundle.vim ' . s:editorRoot . '/bundle/Vundle.vim'
    let vundleInstalled=0
endif

set nocompatible " be iMproved, required.
filetype off 

if has('win32')
    set rtp+=$VIM/vimfiles/bundle/Vundle.vim/
elseif has('nvim')
    set rtp+=$HOME/.config/nvim/bundle/Vundle.vim/
endif


" Vundle plugins.
"=======================
if has('win32')
    call vundle#begin('$VIM/vimfiles/bundle')
else
    call vundle#begin()
endif
" General plugins
"=======================
" Let Vundle handle itself.
Plugin 'VundleVim/Vundle.vim'

" Autocomplete
Plugin 'lifepillar/vim-mucomplete'

" Undo tree.
Plugin 'mbbill/undotree'

" Fuzzy file search
Plugin 'junegunn/fzf'

" Easy motion.
Plugin 'easymotion/vim-easymotion'

" Colour schemes
"=======================
" Dark theme
Plugin 'dracula/vim'

" IDE-like plugins
"=======================
" Tree explorer for Vim.
Plugin 'scrooloose/nerdtree'

" Bar with tags.
Plugin 'majutsushi/tagbar'

" GLSL syntax highlighting.
Plugin 'tikhomirov/vim-glsl'

" Commenter for all code!
Plugin 'scrooloose/nerdcommenter'

" Fast folding
Plugin 'Konfekt/FastFold'

" Better statusline
Plugin 'itchyny/lightline.vim'

" Git plugin for NerdTree
Plugin 'Xuyuanp/nerdtree-git-plugin'

" Indentation guides.
Plugin 'nathanaelkane/vim-indent-guides'

" Autocomplete pairs.
Plugin 'Raimondi/delimitMate'

" Auto-align.
Plugin 'junegunn/vim-easy-align'

" Clang format.
Plugin 'rhysd/vim-clang-format'

" Black (formatter for Python)
Plugin 'psf/black'

" ALE linter.
Plugin 'dense-analysis/ale'

" Language support
"=======================
" LaTeX support.
Plugin 'lervag/vimtex'

" Python.
Plugin 'davidhalter/jedi-vim'

" C/C++
Plugin 'xavierd/clang_complete'

" Pandoc plugins.
Plugin 'vim-pandoc/vim-pandoc'
Plugin 'vim-pandoc/vim-pandoc-syntax'

" Checkbox toggle for markdown.
Plugin 'jkramer/vim-checkbox'

" Simple compile for C++.
Plugin 'xuhdev/SingleCompile'

" Miscellaneous
"=======================
" Better startup screen
Plugin 'mhinz/vim-startify'

call vundle#end()

if vundleInstalled == 0
    echo 'Installing plugins'
    echo ''
    :BundleInstall
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
set completeopt+=menuone,noselect
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
" Undotree
if has("persistent_undo")
    set undodir=~/.undodir/
    set undofile
endif

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

" ALE
let g:ale_set_loclist = 0
let g:ale_set_quickfix = 1
let g:ale_open_list = 1

" Clang complete
let g:clang_use_library = 1
if has('win32') || has('win64')
    let g:clang_library_path = 'C:\Program Files\LLVM\bin'
elseif has('unix')
    let g:clang_library_path = '/usr/lib/llvm-12/lib/libclang-12.so.1'
endif

" Clang format
let g:clang_format#auto_format = 1
let g:clang_format#enable_fallback_style = 0
if has('unix')
    let g:clang_format#command = 'clang-format-12'
endif

" Single compile
if has('win32') || has('win64')
    call SingleCompile#SetCompilerTemplate('cpp', 'clang-cl', 'Windows Clang', 'clang-cl', '/std:c++20 /EHsc /Od /W3 -o $(FILE_TITLE)$', '$(FILE_TITLE)$')
    call SingleCompile#SetOutfile('cpp', 'clang-cl', '$(FILE_TITLE)$.exe')
endif

let g:SingleCompile_alwayscompile = 0
let g:SingleCompile_showquickfixiferror = 1
let g:SingleCompile_showquickfixifwarning = 1
let g:SingleCompile_showresultafterrun = 1

" Checkbox 
let g:insert_checkbox = '\<'
let g:insert_checkbox_prefix = ''
let g:insert_checkbox_suffix = ' '

" FastFold
let g:fastfold_savehook = 1
let g:markdown_folding = 1
let g:tex_fold_enabled = 1

" Lightline
let g:lightline = { 'colorscheme': 'darcula' }

" Autocommands
"=======================
" Ensure that .tex is mapped into LaTeX
autocmd InsertEnter * silent! :set nornu number
autocmd InsertLeave,BufNewFile,VimEnter * silent! :set rnu number

" Highlight TODO, FIXME, and NOTE in all files.
autocmd Syntax * call matchadd('Todo', '\W\zs\(TODO\|FIXME\|CHANGED\|XXX\|BUG\|HACK\)')
autocmd Syntax * call matchadd('Debug', '\W\zs\(NOTE\|INFO\|IDEA\)')

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
nmap <F7> :NERDTree<CR>
nmap <F8> :TagbarToggle<CR>

" Autocommands
"=======================
" Black: format on save.
augroup black_on_save:
    autocmd!
    autocmd BufWritePre *.py Black
augroup end

" Treat C as C++. This is mainly in the off-chance that I ever work with C again. If
" something comes up, we can just make a new file in after/ftplugin
augroup c_as_cpp:
    autocmd!
    autocmd BufRead,BufNewFile *.h,*.c set filetype=cpp
augroup end


