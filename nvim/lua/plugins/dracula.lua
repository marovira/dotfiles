local config = function()
    vim.g.dracula_colorterm = false
    vim.cmd("colorscheme dracula")
end

return {
    {
        "dracula/vim",
        lazy = false,
        priority = 1000,
        config = config,
    },
}
