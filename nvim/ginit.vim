if exists("g:neovide")
    if has('win32')
        set guifont=FiraCode\ Nerd\ Font:h11
    endif

    let g:neovide_transparency=0.9
    let g:neovide_floating_blur_x = 2.0
    let g:neovide_floating_blur_amount_y = 2.0
    let g:neovide_cursor_animation_length = 0
    let g:neovide_remember_window_size = v:false
    let g:neovide_hide_mouse_when_typing = v:true
endif
