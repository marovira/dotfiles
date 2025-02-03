local common = require("common")
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
        "iguanacucumber/magazine.nvim",
        name = "nvim-cmp",
        enabled = true,
        event = "InsertEnter",
        dependencies = {
            { "iguanacucumber/mag-nvim-lsp", name = "cmp-nvim-lsp", opts = {} },
            { "hrsh7th/cmp-nvim-lsp-signature-help" },
            { "https://codeberg.org/FelipeLema/cmp-async-path" },
            { "iguanacucumber/mag-buffer", name = "cmp-buffer" },
            { "iguanacucumber/mag-cmdline", name = "cmp-cmdline" },
            { "f3fora/cmp-spell" },
            { "hrsh7th/cmp-omni" },
            { "onsails/lspkind.nvim" },
            {
                "L3MON4D3/LuaSnip",
                version = "v2.*",
                dependencies = { "rafamadriz/friendly-snippets" },
            },
        },
        config = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")
            local lspkind = require("lspkind")
            require("luasnip.loaders.from_vscode").lazy_load()

            cmp.setup({
                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },
                formatting = {
                    format = function(entry, vim_item)
                        if vim.tbl_contains({ "path" }, entry.source.name) then
                            local icon, hl_group = require("nvim-web-devicons").get_icon(
                                entry:get_completion_item().label
                            )
                            if icon then
                                vim_item.kind = icon
                                vim_item.kind_hl_group = hl_group
                                return vim_item
                            end
                        end
                        return lspkind.cmp_format({ with_text = true })(entry, vim_item)
                    end,
                },
                snippet = {
                    expand = function(args) luasnip.lsp_expand(args.body) end,
                },
                mapping = {
                    ["<C-space>"] = function()
                        if cmp.visible_docs() then
                            cmp.close_docs()
                        else
                            cmp.open_docs()
                        end
                    end,
                    ["<C-e>"] = cmp.mapping.close(),
                    ["<C-y>"] = cmp.mapping.confirm({ select = true }),
                    ["<Up>"] = cmp.mapping.select_prev_item({
                        behavior = cmp.SelectBehavior.Insert,
                    }),
                    ["<Down>"] = cmp.mapping.select_next_item({
                        behavior = cmp.SelectBehavior.Insert,
                    }),
                    ["<C-p>"] = cmp.mapping.select_prev_item({
                        behavior = cmp.SelectBehavior.Insert,
                    }),
                    ["<C-n>"] = cmp.mapping.select_next_item({
                        behavior = cmp.SelectBehavior.Insert,
                    }),
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if luasnip.locally_jumpable(1) then
                            luasnip.jump(1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if luasnip.locally_jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                },
                sources = {
                    {
                        name = "nvim_lsp",
                        option = {
                            enable_in_context = function()
                                return common.in_treesitter_capture("comment")
                                    or common.in_syntax_group("Comment")
                            end,
                        },
                    },
                    {
                        name = "luasnip",
                    },
                    {
                        name = "nvim_lsp_signature_help",
                        option = {
                            enable_in_context = function()
                                return common.in_treesitter_capture("comment")
                                    or common.in_syntax_group("Comment")
                            end,
                        },
                    },
                    { name = "buffer", keyword_length = 3 },
                    { name = "async_path" },
                    {
                        name = "spell",
                        option = {
                            enable_in_context = function()
                                return common.in_treesitter_capture("spell")
                                    or vim.bo.filetype == "markdown"
                                    or vim.bo.filetype == "gitcommit"
                                    or vim.bo.filetype == "tex"
                                    or vim.bo.filetype == "text"
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

            cmp.setup.cmdline("/", {
                mapping = cmp.mapping.preset.cmdline(),
                sources = {
                    { name = "buffer" },
                },
            })
            cmp.setup.cmdline(":", {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources({
                    { name = "path" },
                }, {
                    {
                        name = "cmdline",
                        option = {
                            ignore_cmds = { "Man", "!" },
                        },
                    },
                }),
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
