return {
    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            { "L3MON4D3/LuaSnip" },
            { "hrsh7th/cmp-nvim-lsp" },
            { "hrsh7th/cmp-nvim-lsp-signature-help" },
            { "hrsh7th/cmp-path" },
            { "hrsh7th/cmp-buffer" },
            { "f3fora/cmp-spell" },
        },
        config = function()
            require("lsp-zero.cmp").extend({
                set_sources = "recommended",
                set_basic_mappings = true,
                set_extra_mappings = true,
                use_luasnip = true,
                set_format = true,
                documentation_window = true,
            })

            local cmp = require("cmp")
            local cmp_action = require("lsp-zero").cmp_action()
            local context = require("cmp.config.context")
            cmp.setup({
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
                                    or vim.bo.filetype == "pandoc"
                            end,
                        },
                    },
                    { name = "path" },
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
                },
            })
        end,
    },
}
