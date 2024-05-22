local config = function()
    vim.keymap.set("n", "<F5>", ":UndotreeToggle<CR>")
end

return {
    {
        "mbbill/undotree",
        config = config,
    },
}
