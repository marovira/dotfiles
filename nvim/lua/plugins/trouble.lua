return {
    {
        "folke/trouble.nvim",
        dependencies = {
            { "nvim-tree/nvim-web-devicons" },
        },
        opts = {
            position = "bottom",
        },
        config = function()
            vim.keymap.set("n", "<leader>xx", function()
                require("trouble").open()
            end)
        end,
    },
}
