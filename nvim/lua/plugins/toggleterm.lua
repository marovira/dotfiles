local opts = {
    open_mapping = "<C-\\>",
    start_in_insert = true,
    direction = "float",
    close_on_exit = true,
}

return {
    {
        "akinsho/toggleterm.nvim",
        version = "*",
        opts = opts,
    },
}
