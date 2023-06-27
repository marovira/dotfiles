require('lint').linters_by_ft = {
    python = {'pylint'}
}

require("formatter").setup({
    logging = true,
    filetype = {
        python = {require("formatter.filetypes.python").black},
        cpp = {require("formatter.filetypes.cpp").clangformat},
        ["*"] = {require("formatter.filetypes.any").remove_trailing_whitespace}
    }
})


vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.termguicolors = true

require('nvim-tree').setup()
