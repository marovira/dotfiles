local config = function()
	vim.g.startify_skiplist = { "COMMIT_EDITMSG" }
	vim.g.startify_change_dir = false
end
return {
	{
		"mhinz/vim-startify",
		config = config,
	},
}
