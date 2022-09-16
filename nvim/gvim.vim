" Remove menus
set guioptions-=m       " Remove menu bar
set guioptions-=T       " Remove toolbar
set guioptions-=r       " Remove right scroll bar
set guioptions-=L       " Remove left scroll bar

" Select font based on the OS.
if has('gui_running')
    if has('gui_gtk2')
        set guifont=Inconsolata\12
    elseif has('gui_macvim')
        set guifont=Menlo\ Regular:h14
    elseif has('gui_win32')
        set guifont=Consolas:h11:cANSI
    endif
endif

" Set the window size only if we're running UI.
if has('gui_running')
    set lines=50 columns=100
endif
