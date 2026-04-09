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
        "mrcjkb/rustaceanvim",
        version = "*",
        lazy = false,
    },
}
