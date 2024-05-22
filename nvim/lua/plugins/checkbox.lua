local config = function()
    vim.g.insert_checkbox = "\\<"
    vim.g.insert_checkbox_prefix = ""
    vim.g.insert_checkbox_suffix = " "
end

return {
    {
        "jkramer/vim-checkbox",
        config = config,
    },
}
