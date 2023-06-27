local lsp = require('lsp-zero').preset({
    manage_nvim_cmp = {
        set_sources = 'recommended',
        set_basic_mappings = true,
        set_extra_mappings = true,
        use_luasnip = true,
        set_format = true,
        documentation_window = true,
    }
})

lsp.on_attach(function(client, bufnr)
  lsp.default_keymaps({buffer = bufnr})
end)

lsp.ensure_installed({
    'lua_ls',
    'clangd',
    'jedi_language_server',
    'cmake',
})

local lspconfig = require('lspconfig')
lspconfig.lua_ls.setup(lsp.nvim_lua_ls())


lsp.setup()

function Enable_cmp(enable)
    local cmp = require('cmp')
    local cmp_action = require('lsp-zero').cmp_action()

    if enable then
        cmp.setup({
            enabled = function()
                local context = require 'cmp.config.context'
                if context.in_treesitter_capture('comment') == true or context.in_syntax_group('Comment') then
                    return false
                else
                    return true
                end
            end,
            sources = {
                { name = 'path' },
                { name = 'nvim_lsp' },
                { name = 'nvim_lsp_signature_help' },
                { name = 'buffer', keyword_length = 3 },
            },
            mapping = {
                ['<Tab>'] = cmp_action.tab_complete(),
                ['<S-Tab>'] = cmp_action.select_prev_or_fallback(),
            }
        })
    else
        cmp.setup({ enabled = false })
    end
end
