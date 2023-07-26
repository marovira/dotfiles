return {
    {
        "neovim/nvim-lspconfig",
        cmd = "LspInfo",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            { "williamboman/mason-lspconfig.nvim" },
            {
                "williamboman/mason.nvim",
                build = function()
                    pcall(vim.api.nvim_command, "MasonUpdate")
                end,
            },
        },
        config = function()
            local lsp = require("lsp-zero")
            local lspconfig = require("lspconfig")

            lsp.on_attach(function(client, bufnr)
                lsp.default_keymaps({ buffer = bufnr })
            end)

            lsp.ensure_installed({
                "lua_ls",
                "clangd",
                "pylsp",
                "cmake",
            })

            lspconfig.lua_ls.setup(lsp.nvim_lua_ls())
            lspconfig.pylsp.setup({
                settings = {
                    pylsp = {
                        plugins = {
                            autopep8 = { enabled = false },
                            flake8 = { enabled = false },
                            mccabe = { enabled = false },
                            pycodestyle = { enabled = false },
                            pydocstyle = { enabled = false },
                            pyflakes = { enabled = false },
                            pylint = { enabled = false },
                        },
                    },
                },
            })

            lsp.setup()
        end,
    },
}
