package.path = package.path .. ";../../lua;"
local common = require("common")

vim.b.ale_linters = { "clangtidy" }
vim.b.ale_fixers = { "clang-format" }
vim.b.ale_linters_explicit = true
vim.b.ale_lint_on_text_changed = false
vim.b.ale_lint_on_insert_leave = true
vim.b.ale_lint_on_save = true
vim.b.ale_lint_on_enter = true

-- Linux naming conventions for clang are different than on Windows (shocking) so let's
-- set them up correctly. Assume Clang 18.
if common.is_windows() or common.is_mac() then
    vim.b.ale_c_clangformat_executable = "clang-format"
    vim.b.ale_cpp_cc_executable = "clang++"
else
    vim.b.ale_c_clangformat_executable = "clang-format-18"
    vim.b.ale_cpp_cc_executable = "clang++-18"
end

vim.g.ale_cpp_cc_options = "-std=c++20 -Wall --pedantic"
vim.g.ale_cpp_clangd_options = "--header-insertion=never"
