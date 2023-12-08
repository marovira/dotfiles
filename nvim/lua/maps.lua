-- Remap ESC to jk (insert mode only)
vim.keymap.set("i", "jk", "<ESC>")

-- Toggle numbers
local number_mode = false
vim.keymap.set("n", "<C-n>", function()
    if number_mode then
        vim.opt.number = true
        vim.opt.relativenumber = true
        number_mode = false
    else
        vim.opt.number = true
        vim.opt.relativenumber = false
        number_mode = true
    end
end)

-- Clear search highlight
vim.keymap.set("n", "<ESC>", ":noh<CR><ESC>", { silent = true })

-- Play macro stored in buffer q with the space bar.
vim.keymap.set("n", "<Space>", "@q")
