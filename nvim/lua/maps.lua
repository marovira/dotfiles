-- Remap ESC to jk (insert mode only)
vim.keymap.set("i", "jk", "<ESC>")

-- Paste options.
vim.keymap.set("n", "<F2>", "set invpaste paste?<CR>")
vim.keymap.set("i", "<F2> <C-O>", "set invpaste paste?<CR>", { remap = true })
vim.opt.pastetoggle = "<F2>"

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

-- Buffer navigation
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")
vim.keymap.set("n", "<C-j>", "<C-w>j")

-- Play macro stored in buffer q with the space bar.
vim.keymap.set("n", "<Space>", "@q")