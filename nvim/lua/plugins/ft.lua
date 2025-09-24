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
        "opdavies/toggle-checkbox.nvim",
        ft = "markdown",
        keys = {
            {
                "<leader>tc",
                function() require("toggle-checkbox").toggle() end,
                mode = "n",
                ft = "markdown",
                desc = "Toggle checkbox",
            },
        },
    },
    {
        "xuhdev/SingleCompile",
        cond = function() return common.is_windows() end,
        ft = "cpp",
        config = function()
            vim.g.SingleCompile_alwayscompile = false
            vim.g.SingleCompile_showquickfixiferror = true
            vim.g.SingleCompile_showquickfixifwarning = true
            vim.g.SingleCompile_showresultafterrun = true

            vim.cmd([[
                call SingleCompile#SetCompilerTemplate("cpp", "clang++", "LLVM Clang", "clang++", "-std=c++20 -Wall -Wextra --pedantic -Werror -g -O0 -DDEBUG -o $(FILE_EXEC)$", "$(FILE_RUN)$")
                call SingleCompile#SetOutfile('cpp', 'clang++', '$(FILE_RUN)$')
            ]])
        end,
        keys = {
            {
                "<leader>sc",
                "<cmd>SCCompileRun<cr>",
                desc = "Run Single-Compile",
            },
        },
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
                desc = "Clangd show type hierarchy",
            },
            {
                "<leader>ca",
                "<cmd>ClangdAST<cr>",
                desc = "Clangd AST viewer",
            },
        },
    },
    {
        "Civitasv/cmake-tools.nvim",
        dependencies = {
            { "nvim-lua/plenary.nvim" },
            { "mfussenegger/nvim-dap" },
            { "akinsho/toggleterm.nvim" },
        },
        opts = {
            cmake_build_directory = "build",
        },
        ft = "cpp",
        keys = {
            {
                "<leader>mg",
                "<cmd>CMakeGenerate<cr>",
                desc = "CMake generate",
            },
            {
                "<leader>mb",
                "<cmd>CMakeBuild<cr>",
                desc = "CMake build",
            },
            {
                "<leader>mr",
                "<cmd>CMakeRun<cr>",
                desc = "CMake run",
            },
        },
    },
    {
        "mrcjkb/rustaceanvim",
        version = "^6",
        lazy = false,
    },
}
