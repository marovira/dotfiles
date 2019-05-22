" Functions
"=======================
function ToggleNumbers()
    if &number == 1
        set nonumber rnu
    else
        set number nornu
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
set infercase	                " Adjust case of match for keyword completion
set laststatus=2                " Always show status bar
set lazyredraw	                " Only redraws what is necessary, when necessary :redraw to force
set modeline	                " Enable top-of-file modelines NOTE: security concerns with these
set mouse=a	                    " Enable Mouse Clicks
set mousefocus	                " Focus follows mouse
set mousehide	                " Hides pointer while typing
set nostartofline               " Don't move cusor on line jumps
set number	                    " Enable Line numbers
set number	                    " Show line numbers
set ruler	                    " Show column and character in file
set spell 	                    " Spelling
set tw=80 	                    " Text Width
set wildmenu                    " Auto completion in commandline

" File format settings.
set encoding=utf-8
set fileformat=unix
set fileformats=unix,dos

" Tab settings
set tabstop=4 softtabstop=4 shiftwidth=4 expandtab

" Syntax and file detection.
syntax on
filetype plugin indent on

" Key remaps
"=======================
" Language settings.
nnoremap <F4> :setlocal spell! spelllang=en<CR>
imap <F4> <C-O>:setlocal spell! spelllang-en<CR>

" Toggle numbers.
nnoremap <C-n> :call ToggleNumbers()<CR>

" Clear search highlight.
nnoremap <silent> <ESC> :noh<CR><ESC>

" Remap esc to jk.
inoremap jk <ESC>

" Map leader to comma.
let mapleader = ","

" Buffer navigation.
nnoremap <C-h> <C-w>h
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <C-j> <C-w>j

" Play macro stored in buffer q with the space bar
nnoremap <Space> @q
