return {
    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            {"L3MON4D3/LuaSnip"},
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
            cmp.setup({
                mapping = {
                    ["<Tab>"] = cmp_action.tab_complete(),
                    ["<S-Tab>"] = cmp_action.select_prev_or_fallback(),
                },
            })
        end
    }
}
