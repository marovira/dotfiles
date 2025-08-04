package.path = package.path .. ";../../lua;"
local common = require("common")

-- Disable linting for Objective-C.
vim.b.ale_linters = nil
vim.b.ale_fixers = { "clang-format" }
vim.b.ale_linters_explicit = true

-- Linux naming conventions for clang are different than on Windows (shocking) so let's
-- set them up correctly. Assume Clang 15.
if common.is_windows() or common.is_mac() then
    vim.b.ale_c_clangformat_executable = "clang-format"
else
    vim.b.ale_c_clangformat_executable = "clang-format-18"
end

vim.g.ale_objcpp_clang_options = "-std=c++20 -Wall --pedantic"
vim.g.ale_objcpp_clangd_options = "--header-insertion=never"
