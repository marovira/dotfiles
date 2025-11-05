package.path = package.path .. ";../../lua;"
local common = require("common")

-- List of supported clang versions. As newer versions are tested, add them here.
local llvm_versions = { "18", "19", "20", "21" }

vim.g.ale_cpp_cc_options = "-std=c++20 -Wall --pedantic"
vim.g.ale_cpp_clangd_options = "--header-insertion=never"

vim.b.ale_linters = { "clangtidy" }
vim.b.ale_fixers = { "clang-format" }
vim.b.ale_linters_explicit = true
vim.b.ale_lint_on_text_changed = false
vim.b.ale_lint_on_insert_leave = true
vim.b.ale_lint_on_save = true

if common.is_windows() or common.is_mac() then
    vim.b.ale_cpp_cc_executable = "clang++"
    vim.b.ale_cpp_clangformat_executable = "clang-format"
    vim.b.ale_cpp_clangtidy_executable = "clang-tidy"
else
    local clang = "clang++-"
    local fmt = "clang-format-"
    local tidy = "clang-tidy-"
    for _, ver in ipairs(llvm_versions) do
        if vim.fn.executable(clang .. ver) == 1 then
            vim.b.ale_cpp_cc_executable = clang .. ver
        end
        if vim.fn.executable(fmt .. ver) == 1 then
            vim.b.ale_cpp_clangformat_executable = fmt .. ver
        end
        if vim.fn.executable(tidy .. ver) == 1 then
            vim.b.ale_cpp_clangtidy_executable = tidy .. ver
        end
    end
end

if common.is_windows() then
    vim.opt_local.makeprg =
        "clang++ -std=c++20 -Wall -Wextra -Werror --pedantic -g -O0 -DDEBUG -o %:r %"
end
