" Options
"=======================
set backspace=start,indent,eol  " Backspace works on everything
set cursorline	                " Show current cursor line
set hlsearch	                " Highlights search
set incsearch                   " Incremental search
set laststatus=2                " Always show status bar
set modeline	                " Enable top-of-file modelines NOTE: security concerns with these
set nostartofline               " Don't move cusor on line jumps
set number	                    " Enable Line numbers
set tw=80 	                    " Text Width
set number relativenumber

" Tab settings
set tabstop=4 softtabstop=4 shiftwidth=4 expandtab

" Key remaps
"=======================
" Language settings.
nnoremap <F4> :setlocal spell! spelllang=en<CR>
imap <F4> <C-O>:setlocal spell! spelllang-en<CR>

" Toggle numbers.
nnoremap <C-n> :call ToggleNumbers()<CR>

" Clear search highlight.
nnoremap <ESC> :noh<CR><ESC>

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

" Tell vim to use the system register.
set clipboard=unnamed

nnoremap <Leader>cc :vsc Edit.CommentSelection<CR>
nnoremap <Leader>cu :vsc Edit.UncommentSelection<CR>
nnoremap <Leader>f :vsc Edit.FormatSelection<CR>

vnoremap <Leader>cc :vsc Edit.CommentSelection<CR>
vnoremap <Leader>cu :vsc Edit.UncommentSelection<CR>
vnoremap <Leader>f :vsc Edit.FormatSelection<CR>
