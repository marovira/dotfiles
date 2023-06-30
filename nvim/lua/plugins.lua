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


vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.termguicolors = true

require('nvim-tree').setup()
