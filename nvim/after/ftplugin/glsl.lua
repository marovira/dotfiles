-- Disable linting, but keep clang-format
-- TODO: Can we figure out how to setup the linter from glslang? It would help a lot when
-- writing shader code.
vim.b.ale_linters = nil
vim.b.ale_fixers = { "clang-format" }
vim.b.ale_linters_explicit = true

vim.opt_local.smartindent = true
