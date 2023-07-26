return {
    {
        "mhinz/vim-startify",
        config = function()
            vim.g.startify_skiplist = { "COMMIT_EDITMSG" }
        end,
    },
}
