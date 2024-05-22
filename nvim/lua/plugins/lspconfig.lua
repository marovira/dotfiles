local config = function()
    local lsp_zero = require("lsp-zero")
    local lspconfig = require("lspconfig")
    local mason_lsp = require("mason-lspconfig")

    lsp_zero.extend_lspconfig()
    lsp_zero.on_attach(function(_, bufnr)
        lsp_zero.default_keymaps({ buffer = bufnr })
    end)

    mason_lsp.setup({
        ensure_installed = {
            "lua_ls",
            "clangd",
            "pylsp",
            "cmake",
        },
        handlers = {
            function(server_name)
                lspconfig[server_name].setup({})
            end,

            lua_ls = function()
                lspconfig.lua_ls.setup(lsp_zero.nvim_lua_ls())
            end,

            pylsp = function()
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
            end,
        },
    })
end

return {
    {
        "neovim/nvim-lspconfig",
        cmd = { "LspInfo", "LspInstall", "LspStart" },
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            { "VonHeikemen/lsp-zero.nvim" },
            { "williamboman/mason-lspconfig.nvim" },
        },
        config = config,
    },
}
