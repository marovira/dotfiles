local common = require("common")
local spell = require("extra.cmp-spell")

---@param kind string
---@return string
local function fs_kind_to_mini_category(kind)
    local category = "default"
    if kind == "Folder" then
        category = "directory"
    elseif kind == "File" then
        category = "file"
    end

    return category
end

---@module "blink.cmp"
---@param ctx blink.cmp.DrawItemContext
---@return string
local function get_blink_text(ctx)
    local icon = ctx.kind_icon
    local mini = require("mini.icons")
    local lspkind = require("lspkind")

    if vim.tbl_contains({ "LSP" }, ctx.source_name) then
        local mini_icon, _, _ = mini.get("lsp", ctx.kind)
        if mini_icon then icon = mini_icon end
    elseif vim.tbl_contains({ "Path" }, ctx.source_name) then
        local mini_icon = mini.get(fs_kind_to_mini_category(ctx.kind), ctx.label)
        if mini_icon then icon = mini_icon end
    elseif
        vim.tbl_contains({ "spell", "cmdline", "markdown", "Dict" }, ctx.source_name)
    then
        local lsp_icon = lspkind.symbolic(ctx.source_name, { mode = "symbol" })
        if lsp_icon then icon = lsp_icon end
    end
    return icon
end

---@param ctx blink.cmp.DrawItemContext
---@return string
local function get_blink_hl(ctx)
    local hl = "BlinkCmpKind" .. ctx.kind
        or require("blink.cmp.completion.windows.render.tailwind").get_hl(ctx)

    local mini = require("mini.icons")

    if vim.tbl_contains({ "LSP" }, ctx.source_name) then
        local mini_icon, mini_hl, _ = mini.get("lsp", ctx.kind)
        if mini_icon then hl = mini_hl end
    elseif vim.tbl_contains({ "Path" }, ctx.source_name) then
        local mini_icon, mini_hl, _ =
            mini.get(fs_kind_to_mini_category(ctx.kind), ctx.label)
        if mini_icon then hl = mini_hl end
    end

    return hl
end

return {
    {
        "dense-analysis/ale",
        event = "VeryLazy",
        init = function()
            vim.cmd([[
                let g:ale_fixers = {'*': ['remove_trailing_lines', 'trim_whitespace']}
            ]])
            vim.g.ale_set_loclist = false
            vim.g.ale_set_quickfix = false
            vim.g.ale_use_neovim_diagnostics_api = true
            vim.g.ale_open_list = true
            vim.g.ale_fix_on_save = true
            vim.g.ale_disable_lsp = true

            -- Disable cursor messages.
            vim.g.ale_echo_cursor = 0
            vim.g.ale_cursor_detail = 0
        end,
    },
    {
        "mason-org/mason.nvim",
        version = "*",
        opts = {},
    },
    {
        "mason-org/mason-lspconfig.nvim",
        dependencies = {
            { "mason-org/mason.nvim" },
            { "neovim/nvim-lspconfig", version = "*" },
        },
        version = "*",
        opts = {
            ensure_installed = {
                "lua_ls",
                "clangd",
                "pylsp",
                "cmake",
                "marksman",
            },
        },
    },
    {
        "folke/lazydev.nvim",
        dependencies = {
            { "DrKJeff16/wezterm-types", lazy = true },
        },
        ft = "lua",
        opts = {
            library = {
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
                { path = "wezterm-types", mods = { "wezterm" } },
            },
        },
    },
    {
        "saghen/blink.cmp",
        version = "*",
        dependencies = {
            { "rafamadriz/friendly-snippets" },
            {
                "onsails/lspkind.nvim",
                opts = {
                    symbol_map = {
                        spell = "󰓆",
                        cmdline = "",
                        markdown = "",
                    },
                },
            },
        },
        opts = {
            enabled = function() return not common.is_buffer_filetype("dap-repl") end,
            keymap = { preset = "default" },
            appearance = {
                use_nvim_cmp_as_default = false,
                nerd_font_variant = "normal",
            },
            completion = {
                menu = {
                    border = "single",
                    draw = {
                        columns = {
                            { "kind_icon" },
                            { "label", "label_description", gap = 1 },
                            -- { "kind" }, -- <- Useful for debugging highlights/completion types.
                            -- { "source_name" }, -- <- Useful for debugging sources.
                        },
                        components = {
                            kind_icon = {
                                ellipsis = false,
                                text = function(ctx)
                                    return get_blink_text(ctx)
                                end,
                                highlight = function(ctx)
                                    return get_blink_hl(ctx)
                                end,
                            },
                            kind = {
                                highlight = function(ctx)
                                    return get_blink_hl(ctx)
                                end,
                            },
                        },
                    },
                },
                documentation = {
                    auto_show = true,
                    window = { border = "single" },
                },
                accept = { auto_brackets = { enabled = false } },
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
                    lsp = {
                        fallbacks = {},
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
                        module = "blink.cmp.sources.complete_func",
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
