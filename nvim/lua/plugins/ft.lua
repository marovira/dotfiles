local common = require("common")

return {
    {
        "lervag/vimtex",
        lazy = false,
    },
    {
        "MeanderingProgrammer/render-markdown.nvim",
        dependencies = {
            { "nvim-treesitter/nvim-treesitter" },
            { "nvim-tree/nvim-web-devicons" },
        },
        ft = "markdown",
        opts = {},
    },
    {
        "xuhdev/SingleCompile",
        cond = function() return common.is_windows() end,
        ft = "cpp",
        config = function()
            vim.cmd([[
                call SingleCompile#SetCompilerTemplate("cpp", "clang++", "LLVM Clang", "clang++", "-std=c++20 -Wall -Wextra --pedantic -Werror -g -O0 -DDEBUG -o $(FILE_EXEC)$", "$(FILE_RUN)$")
                call SingleCompile#SetOutfile('cpp', 'clang++', '$(FILE_RUN)$')
            ]])

            vim.g.SingleCompile_alwayscompile = false
            vim.g.SingleCompile_showquickfixiferror = true
            vim.g.SingleCompile_showquickfixifwarning = true
            vim.g.SingleCompile_showresultafterrun = true

            vim.keymap.set(
                "n",
                "<leader>sc",
                ":SCCompileRun<CR>",
                { desc = "Run Single-Compile" }
            )
        end,
    },
    {
        "p00f/clangd_extensions.nvim",
        ft = "cpp",
        opts = {},
        keys = {
            {
                "<leader>ch",
                "<cmd>ClangdSwitchSourceHeader<cr>",
                desc = "Clangd switch source/header file",
            },
            {
                "<leader>cs",
                "<cmd>ClangdSymbolInfo<cr>",
                desc = "Clangd show symbol info",
            },
            {
                "<leader>ct",
                "<cmd>ClangdTypeHierarchy<cr>",
                desc = "Clagnd show type hierarchy",
            },
        },
    },
}
