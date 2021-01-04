" Global Options
"=======================
set backspace=start,indent,eol  " Backspace works on everything
set cursorline	                " Show current cursor line
set hlsearch	                " Highlights search
set incsearch                   " Incremental search
set laststatus=2                " Always show status bar
set modeline	                " Enable top-of-file modelines NOTE: security concerns with these
set nostartofline               " Don't move cusor on line jumps
set tw=80 	                    " Text Width

" Tab settings
set tabstop=4 softtabstop=4 shiftwidth=4 expandtab

" General key remaps
"=======================
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

" VS commands
"=======================
" Comment/Uncomment selection for both normal and visual modes.
nnoremap <Leader>cc :vsc Edit.CommentSelection<CR>
nnoremap <Leader>cu :vsc Edit.UncommentSelection<CR>
vnoremap <Leader>cc :vsc Edit.CommentSelection<CR>
vnoremap <Leader>cu :vsc Edit.UnCommentSelection<CR>

" Format selection for both normal and visual modes.
nnoremap <Leader>f :vsc Edit.FormatSelection<CR>
vnoremap <Leader>f :vsc Edit.FormatSelection<CR>

" Return to previous position.
nnoremap <C-t> :vsc View.NavigateBackward<CR>

" Open corresponding file.
nnoremap <Leader>o :vsc VAssistX.OpenCorrespondingFile<CR>

" Set/unset breakpoint in current line.
nnoremap <Leader>b :vsc Debug.ToggleBreakpoint<CR>

" Enable/disable breakpoint in current line.
nnoremap <Leader>bt :vsc Debug.EnableBreakpoint<CR>
