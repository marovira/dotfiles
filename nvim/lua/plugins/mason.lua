local build = function()
    pcall(vim.api.nvim_command, "MasonUpdate")
end

return {
    {
        "williamboman/mason.nvim",
        lazy = false,
        config = true,
        build = build,
    },
}
