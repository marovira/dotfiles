-- Use sylua for linting.
vim.b.ale_linters = nil
vim.b.ale_fixers = { "stylua" }
vim.b.ale_linters_explicit = true
vim.g.ale_lua_stylua_options = "--search-parent-directories"
