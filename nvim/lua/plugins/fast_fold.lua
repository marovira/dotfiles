local config = function()
    vim.g.fastfold_savehook = true
    vim.g.markdown_folding = true
    vim.g.tex_fold_enabled = true
end

return {
    {
        "Konfekt/FastFold",
        config = config,
    },
}
