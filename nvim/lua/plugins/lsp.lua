return {
    {
        "VonHeikemen/lsp-zero.nvim",
        branch = "v3.x",
        lazy = true,
        init = function()
            vim.g.lsp_zero_extend_cmp = 0
            vim.g.lsp_zero_extend_lspconfig = 0
        end,
    },
    {
        "neovim/nvim-lspconfig",
        cmd = { "LspInfo", "LspInstall", "LspStart" },
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            { "VonHeikemen/lsp-zero.nvim" },
            { "williamboman/mason-lspconfig.nvim" },
        },
        config = function()
            local lsp_zero = require("lsp-zero")
            local lspconfig = require("lspconfig")
            local mason_lsp = require("mason-lspconfig")

            lsp_zero.extend_lspconfig()
            lsp_zero.on_attach(
                function(_, bufnr) lsp_zero.default_keymaps({ buffer = bufnr }) end
            )

            mason_lsp.setup({
                ensure_installed = {
                    "lua_ls",
                    "clangd",
                    "pylsp",
                    "cmake",
                },
                handlers = {
                    function(server_name) lspconfig[server_name].setup({}) end,

                    lua_ls = function() lspconfig.lua_ls.setup(lsp_zero.nvim_lua_ls()) end,

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
        end,
    },
    {
        "williamboman/mason.nvim",
        lazy = false,
        config = true,
        build = function() pcall(vim.api.nvim_command, "MasonUpdate") end,
    },
    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            { "L3MON4D3/LuaSnip" },
            { "VonHeikemen/lsp-zero.nvim" },
            { "hrsh7th/cmp-nvim-lsp" },
            { "hrsh7th/cmp-nvim-lsp-signature-help" },
            { "https://codeberg.org/FelipeLema/cmp-async-path" },
            { "hrsh7th/cmp-buffer" },
            { "f3fora/cmp-spell" },
            { "hrsh7th/cmp-omni" },
        },
        config = function()
            local lsp_zero = require("lsp-zero")
            local cmp = require("cmp")
            local cmp_action = lsp_zero.cmp_action()
            local context = require("cmp.config.context")
            local cmp_format = lsp_zero.cmp_format({ details = true })

            lsp_zero.extend_cmp()

            cmp.setup({
                formatting = cmp_format,
                mapping = {
                    ["<Tab>"] = cmp_action.tab_complete(),
                    ["<S-Tab>"] = cmp_action.select_prev_or_fallback(),
                },
                sources = {
                    {
                        name = "spell",
                        option = {
                            enable_in_context = function()
                                return context.in_treesitter_capture("spell")
                                    or vim.bo.filetype == "markdown"
                                    or vim.bo.filetype == "gitcommit"
                                    or vim.bo.filetype == "tex"
                                    or vim.bo.filetype == "text"
                            end,
                        },
                    },
                    { name = "async_path" },
                    { name = "buffer", keyword_length = 3 },
                    {
                        name = "nvim_lsp",
                        option = {
                            enable_in_context = function()
                                return context.in_treesitter_capture("comment")
                                    or context.in_syntax_group("Comment")
                            end,
                        },
                    },
                    {
                        name = "nvim_lsp_signature_help",
                        option = {
                            enable_in_context = function()
                                return context.in_treesitter_capture("comment")
                                    or context.in_syntax_group("Comment")
                            end,
                        },
                    },
                    {
                        name = "omni",
                        option = {
                            enable_in_context = function()
                                return vim.bo.filetype == "tex"
                            end,
                        },
                    },
                },
            })
        end,
    },
    {
        "dense-analysis/ale",
        init = function()
            vim.cmd([[
                let g:ale_fixers = {'*': ['remove_trailing_lines', 'trim_whitespace']}
            ]])
            vim.g.ale_set_loclist = false
            vim.g.ale_set_quickfix = false
            vim.g.ale_use_neovim_diagnostics_api = true
            vim.g.ale_open_list = true
            vim.g.ale_fix_on_save = true
        end,
    },
}
