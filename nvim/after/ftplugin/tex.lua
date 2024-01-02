-- Reduce indentation to 2 spaces
vim.opt_local.tabstop = 2
vim.opt_local.shiftwidth = 2
vim.opt_local.softtabstop = 2
vim.opt_local.expandtab = true

-- Disable diagnostic messages.
vim.diagnostic.disable()

-- Plugins
-- =======================
-- Vimtex
vim.b.vimtex_indent_ignored_envs = nil
vim.b.vimtex_fold_enabled = false
vim.b.vimtex_view_method = "general"
vim.b.vimtex_view_general_viewer = "SumatraPDF"
vim.b.vimtex_view_general_options = "-reuse-instance -forward-search @tex @line @pdf"
--vim.g.vimtex_include_search_enabled = 0

-- ALE
vim.b.ale_linters = nil
vim.b.ale_linters_explicit = true

-- Remaps
-- =======================
-- Make Vimtex stop continuous compile before cleaning
vim.keymap.set("n", "<localleader>lc", ":VimtexStop<CR>:VimtexClean<CR>")

-- Make vimtex clean everything when we close the file.
local augroup = vim.api.nvim_create_augroup("vimtex", { clear = true })
vim.api.nvim_create_autocmd({ "User" }, {
    pattern = "VimtexEventQuit",
    group = augroup,
    command = "call vimtex#compiler#clean(0)",
})
