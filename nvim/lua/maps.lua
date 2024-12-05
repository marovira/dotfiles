vim.keymap.set("i", "jk", "<ESC>", { desc = "Remap ESC to jk" })

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
end, { desc = "Toggle between relative and absolute numbers" })

vim.keymap.set(
    "n",
    "<ESC>",
    ":noh<CR><ESC>",
    { silent = true, desc = "Clear search highlight" }
)

vim.keymap.set("n", "<Space>", "@q", { desc = "Play macro stored in buffer q" })
