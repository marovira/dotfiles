local config = function()
    vim.g.startify_skiplist = { "COMMIT_EDITMSG" }
end
return {
    {
        "mhinz/vim-startify",
        config = config,
    },
}
