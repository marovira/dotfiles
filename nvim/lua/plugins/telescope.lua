local config = function()
    local telescope = require("telescope")
    telescope.setup()
    telescope.load_extension("zf-native")
    telescope.load_extension("file_browser")
    telescope.load_extension("undo")

    vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<CR>")
    vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<CR>")
    vim.keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<CR>")
    vim.keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<CR>")
    vim.keymap.set("n", "<leader>fd", "<cmd>Telescope file_browser<CR>")
    vim.keymap.set("n", "<leader>fu", "<cmd>Telescope undo<CR>")
end

return {
    {
        "nvim-telescope/telescope.nvim",
        version = "*",
        dependencies = {
            { "nvim-lua/plenary.nvim" },
            { "natecraddock/telescope-zf-native.nvim" },
            { "nvim-telescope/telescope-file-browser.nvim" },
            { "debugloop/telescope-undo.nvim" },
        },
        config = config,
    },
}
