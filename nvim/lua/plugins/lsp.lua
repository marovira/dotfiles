local common = require("common")
local spell = require("extra.cmp-spell")

---@param ctx blink.cmp.DrawItemContext
---@return string
local function blink_highlight(ctx)
    local hl = "BlinkCmpKind" .. ctx.kind
        or require("blink.cmp.completion.windows.render.tailwind").get_hl(ctx)
    if vim.tbl_contains({ "Path" }, ctx.source_name) then
        local dev_icon, dev_hl = require("nvim-web-devicons").get_icon(ctx.label)
        if dev_icon then hl = dev_hl end
    end
    return hl
end

return {
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
            { "saghen/blink.cmp" },
        },
        config = function()
            local lspconfig = require("lspconfig")
            local mason_lsp = require("mason-lspconfig")
            local lsp_capabilities = require("blink.cmp").get_lsp_capabilities()
            ---@diagnostic disable:missing-fields
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
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
            library = {
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
            },
        },
    },
    {
        "saghen/blink.cmp",
        version = "*",
        dependencies = {
            { "rafamadriz/friendly-snippets" },
            { "MeanderingProgrammer/render-markdown.nvim" },
            {
                "onsails/lspkind.nvim",
                opts = {
                    symbol_map = { spell = "󰓆", cmdline = "", markdown = "" },
                },
            },
        },
        opts = {
            keymap = { preset = "default" },
            appearance = {
                use_nvim_cmp_as_default = true,
                nerd_font_variant = "normal",
            },
            completion = {
                menu = {
                    border = "single",
                    draw = {
                        columns = {
                            { "kind_icon" },
                            { "label", "label_description", gap = 1 },
                            -- { "source_name" }, -- <- Useful for debugging sources.
                        },
                        components = {
                            kind_icon = {
                                ellipsis = false,
                                text = function(ctx)
                                    local lspkind = require("lspkind")
                                    local icon = ctx.kind_icon

                                    if vim.tbl_contains({ "Path" }, ctx.source_name) then
                                        local dev_icon, _ =
                                            require("nvim-web-devicons").get_icon(
                                                ctx.label
                                            )
                                        if dev_icon then icon = dev_icon end
                                    else
                                        if
                                            vim.tbl_contains(
                                                { "spell", "cmdline", "markdown" },
                                                ctx.source_name
                                            )
                                        then
                                            icon = lspkind.symbolic(
                                                ctx.source_name,
                                                { mode = "symbol" }
                                            )
                                        else
                                            icon = lspkind.symbolic(ctx.kind, {
                                                mode = "symbol",
                                            })
                                        end
                                    end

                                    return icon .. ctx.icon_gap
                                end,
                                highlight = function(ctx) return blink_highlight(ctx) end,
                            },
                            kind = {
                                highlight = function(ctx) return blink_highlight(ctx) end,
                            },
                        },
                    },
                },
                documentation = {
                    auto_show = true,
                    window = { border = "single" },
                },
            },
            signature = {
                enabled = true,
                window = { border = "single" },
            },
            sources = {
                default = {
                    "lazydev",
                    "lsp",
                    "omni",
                    "buffer",
                    "path",
                    "spell",
                    "markdown",
                },
                providers = {
                    buffer = {
                        transform_items = function(a, items)
                            return spell:adjust_case(a.get_keyword(), items)
                        end,
                    },
                    lazydev = {
                        name = "LazyDev",
                        module = "lazydev.integrations.blink",
                        score_offset = 100,
                    },
                    spell = {
                        name = "spell",
                        module = "extra.cmp-spell",
                        opts = {},
                    },
                    omni = {
                        name = "Omni",
                        module = "blink.cmp.sources.omni",
                        opts = { disable_omnifuncs = { "v:lua.vim.lsp.omnifunc" } },
                        enabled = function()
                            return common.has_value({ "tex" }, vim.bo.filetype)
                        end,
                    },
                    markdown = {
                        name = "markdown",
                        module = "render-markdown.integ.blink",
                        enabled = function()
                            return common.has_value({ "markdown" }, vim.bo.filetype)
                        end,
                        fallbacks = { "lsp" },
                    },
                },
            },
            cmdline = {
                enabled = true,
                sources = function()
                    local type = vim.fn.getcmdtype()

                    if type == "/" or type == "?" then return { "buffer" } end
                    if type == ":" or type == "@" then
                        return { "cmdline", "path", "buffer" }
                    end
                    return {}
                end,
                completion = {
                    menu = { auto_show = true },
                },
            },
        },
    },
}
