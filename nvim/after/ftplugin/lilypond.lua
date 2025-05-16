-- Reduce indentation to 2 spaces
vim.opt_local.tabstop = 2
vim.opt_local.shiftwidth = 2
vim.opt_local.softtabstop = 2
vim.opt_local.expandtab = true

-- Disable text width
vim.opt_local.textwidth = 0
vim.opt_local.colorcolumn = "0"

vim.b.ale_linters = nil
vim.b.ale_linters_explicit = true

local augroup = vim.api.nvim_create_augroup("lilypond", { clear = true })
vim.api.nvim_create_autocmd({ "BufEnter" }, {
    command = "syntax sync fromstart",
    group = augroup,
})
