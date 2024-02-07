package.path = package.path .. ";../../lua;"
local common = require("common")

-- Single-compile
vim.keymap.set("n", "<F9>", ":SCCompile<CR>")
vim.keymap.set("n", "<F10>", ":SCCompileRun<CR>")

-- No linting (I would have to figure out which settings I want for a clang-tidy file, and
-- I honestly don't think it's worth it), but keep formatting.
vim.b.ale_linters = nil
vim.b.ale_fixers = { "clang-format" }
vim.b.ale_linters_explicit = true

-- Linux naming conventions for clang are different than on Windows (shocking) so let's
-- set them up correctly. Assume Clang 15.
if common.is_windows() or common.is_mac() then
    vim.b.ale_c_clangformat_executable = "clang-format"
else
    vim.b.ale_c_clangformat_executable = "clang-format-15"
end
