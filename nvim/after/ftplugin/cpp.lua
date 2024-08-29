package.path = package.path .. ";../../lua;"
local common = require("common")

-- No linting (I would have to figure out which settings I want for a clang-tidy file, and
-- I honestly don't think it's worth it), but keep formatting.
vim.b.ale_linters = { "clangd" }
vim.b.ale_fixers = { "clang-format" }
vim.b.ale_linters_explicit = true

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

-- Override the commentstring for cpp.
vim.bo.commentstring = "// %s"
