return {
    {
        "lervag/vimtex",
        lazy = false,
    },
    {
        "MeanderingProgrammer/render-markdown.nvim",
        dependencies = {
            { "nvim-treesitter/nvim-treesitter" },
            { "nvim-mini/mini.nvim" },
        },
        ft = "markdown",
        opts = {},
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
