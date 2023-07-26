return {
    {
        "nvim-tree/nvim-tree.lua",
        version = "*",
        lazy = false,
        dependencies = {
            { "nvim-tree/nvim-web-devicons" },
        },
        config = function()
            vim.g.loaded_netrw = 1
            vim.g.loaded_netrwPlugin = 1
            vim.opt.termguicolors = true

            require("nvim-tree").setup()
            vim.keymap.set("n", "<F7>", ":NvimTreeToggle<CR>")
        end,
    },
}
