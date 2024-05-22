local config = function()
    vim.keymap.set("n", "<leader>tc", ":lua require('toggle-checkbox').toggle()<CR>")
end

return {
    {
        "opdavies/toggle-checkbox.nvim",
        ft = "markdown",
        config = config,
    },
}
