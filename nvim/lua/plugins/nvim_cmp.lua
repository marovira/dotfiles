local config = function()
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
end

return {
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
        config = config,
    },
}
