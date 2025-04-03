local common = require("common")

if vim.g.neovide then
    if common.is_windows() then vim.o.guifont = "FiraCode Nerd Font:h11" end

    vim.g.neovide_opacity = 0.9
    vim.g.neovide_floating_blur_amount_x = 2.0
    vim.g.neovide_floating_blur_amount_y = 2.0
    vim.g.neovide_cursor_animation_length = 0
    vim.g.neovide_scroll_animation_length = 0
    vim.g.neovide_remember_window_size = false
    vim.g.neovide_hide_mouse_when_typing = true
end
