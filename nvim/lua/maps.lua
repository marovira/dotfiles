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

-- LSP diagnostic keymaps
vim.keymap.set(
    "n",
    "gl",
    "<cmd>lua vim.diagnostic.open_float()<cr>",
    { desc = "LSP diagnostic open float" }
)
vim.keymap.set(
    "n",
    "[d",
    "<cmd>lua vim.diagnostic.goto_prev()<cr>",
    { desc = "LSP go to previous diagnostic" }
)
vim.keymap.set(
    "n",
    "]d",
    "<cmd>lua vim.diagnostic.goto_next()<cr>",
    { desc = "LSP go to next diagnostic" }
)
