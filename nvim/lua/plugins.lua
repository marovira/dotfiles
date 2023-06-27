require('lint').linters_by_ft = {
    python = {'pylint'}
}

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.termguicolors = true

require('nvim-tree').setup()
