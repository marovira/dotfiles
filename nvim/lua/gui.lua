local common = require("common")

if vim.g.neovide then
    if common.is_windows() then vim.o.guifont = "FiraCode Nerd Font:h11" end

    local default_opacity = common.is_windows() and 0.5 or 0.8
    vim.g.neovide_opacity = default_opacity
    vim.g.neovide_window_blurred = true
    vim.g.neovide_floating_blur_amount_x = 2.0
    vim.g.neovide_floating_blur_amount_y = 2.0
    vim.g.neovide_cursor_animation_length = 0
    vim.g.neovide_scroll_animation_length = 0
    vim.g.neovide_remember_window_size = false
    vim.g.neovide_hide_mouse_when_typing = true
end
