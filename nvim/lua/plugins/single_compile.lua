local common = require("common")
return {
    {
        "xuhdev/SingleCompile",
        cond = function()
            return common.is_windows()
        end,
        config = function()
            vim.cmd([[
                call SingleCompile#SetCompilerTemplate('cpp', 'clang-cl', 'Windows Clang', 'clang-cl', '/std:c++20 /EHsc /Od /W3 -o $(FILE_TITLE)$', '$(FILE_TITLE)$')
                call SingleCompile#SetOutfile('cpp', 'clang-cl', '$(FILE_TITLE)$.exe')
            ]])

            vim.g.SingleCompile_alwayscompile = false
            vim.g.SingleCompile_showquickfixiferror = true
            vim.g.SingleCompile_showquickfixifwarning = true
            vim.g.SingleCompile_showresultafterrun = true
        end,
    },
}
