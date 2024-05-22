local opts = {
    position = "bottom",
}

local config = function()
    vim.keymap.set("n", "<leader>xx", function()
        require("trouble").open()
    end)
end
return {
    {
        "folke/trouble.nvim",
        dependencies = {
            { "nvim-tree/nvim-web-devicons" },
        },
        opts = opts,
        config = config,
    },
}
