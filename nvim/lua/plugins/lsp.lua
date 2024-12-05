return {
    {
        "williamboman/mason.nvim",
        lazy = false,
        config = true,
        build = function() pcall(vim.api.nvim_command, "MasonUpdate") end,
    },
    {
        "neovim/nvim-lspconfig",
        cmd = { "LspInfo", "LspInstall", "LspStart" },
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            { "williamboman/mason-lspconfig.nvim" },
            { "hrsh7th/cmp-nvim-lsp" },
        },
        config = function()
            local lspconfig = require("lspconfig")
            local mason_lsp = require("mason-lspconfig")
            local lsp_capabilities = require("cmp_nvim_lsp").default_capabilities()

            mason_lsp.setup({
                ensure_installed = {
                    "lua_ls",
                    "clangd",
                    "pylsp",
                    "cmake",
                },
                handlers = {
                    function(server_name)
                        lspconfig[server_name].setup({
                            capabilities = lsp_capabilities,
                        })
                    end,

                    lua_ls = function()
                        lspconfig.lua_ls.setup({
                            capabilities = lsp_capabilities,
                            settings = {
                                Lua = {
                                    runtime = {
                                        version = "LuaJIT",
                                    },
                                    diagnostics = {
                                        globals = { "vim" },
                                    },
                                    workspace = {
                                        library = {
                                            vim.env.VIMRUNTIME,
                                        },
                                    },
                                },
                            },
                        })
                    end,

                    pylsp = function()
                        lspconfig.pylsp.setup({
                            capabilities = lsp_capabilities,
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
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            { "L3MON4D3/LuaSnip" },
            { "hrsh7th/cmp-nvim-lsp" },
            { "hrsh7th/cmp-nvim-lsp-signature-help" },
            { "https://codeberg.org/FelipeLema/cmp-async-path" },
            { "hrsh7th/cmp-buffer" },
            { "f3fora/cmp-spell" },
            { "hrsh7th/cmp-omni" },
        },
        config = function()
            local cmp = require("cmp")
            local context = require("cmp.config.context")

            cmp.setup({
                snippet = {
                    expand = function(args) vim.snippet.expand(args.body) end,
                },
                mapping = cmp.mapping.preset.insert({
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        local luasnip = require("luasnip")
                        local col = vim.fn.col(".") - 1

                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif luasnip.expand_or_locally_jumpable() then
                            luasnip.expand_or_jump()
                        elseif
                            col == 0 or vim.fn.getline("."):sub(col, col):match("%s")
                        then
                            fallback()
                        else
                            cmp.complete()
                        end
                    end, { "i", "s" }),
                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        local luasnip = require("luasnip")

                        if cmp.visible() then
                            cmp.select_prev_item({ behavior = "select" })
                        elseif luasnip.locally_jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                }),
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
