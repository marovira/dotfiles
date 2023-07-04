
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
    'pylsp',
    'cmake',
})

local lspconfig = require('lspconfig')
lspconfig.lua_ls.setup(lsp.nvim_lua_ls())
lspconfig.pylsp.setup({
    settings = {
        pylsp = {
            plugins = {
                pyflakes = {enabled = false},
                pylint = {enabled = false},
                pycodestyle = {enabled = false}
            }
        }
    }
})


lsp.setup()

require('nvim-treesitter.configs').setup({
    ensure_installed = {
        'c', 'cpp', 'lua', 'vim', 'vimdoc', 'query', 'python', 'cmake', 'glsl', 'bash',
        'gitignore', 'git_config', 'objc'
    },
    sync_install = false,
    auto_install = true,
    highlight = {
        enable = true,
        disable = {'gitcommit', 'markdown'}
    },
})

require('telescope').setup()
require('telescope').load_extension('zf-native')
require('telescope').load_extension('file_browser')


vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.termguicolors = true

require('nvim-tree').setup()
