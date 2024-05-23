local config = function()
    require("telescope").load_extension("toggleterm")
    vim.keymap.set("n", "<leader>t", "<cmd>Telescope toggleterm<CR>")
end

return {
    {
        "da-moon/telescope-toggleterm.nvim",
        event = "TermOpen",
        dependencies = {
            { "akinsho/nvim-toggleterm.lua" },
            { "nvim-telescope/telescope.nvim" },
            { "nvim-lua/popup.nvim" },
            { "nvim-lua/plenary.nvim" },
        },
        config = config,
    },
}
