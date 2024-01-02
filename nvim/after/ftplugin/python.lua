-- Enable linting with pylint and formatting with black.
vim.b.ale_linters = { "pylint", "mypy" }
vim.b.ale_fixers = { "black" }
vim.b.ale_linters_explicit = true
vim.b.ale_lint_on_text_changed = false
vim.b.ale_lint_on_save = true
vim.b.ale_lint_on_enter = true
