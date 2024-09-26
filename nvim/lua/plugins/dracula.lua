local config = function()
	require("tokyonight").setup({
		style = "night",
		transparent = true,
		styles = {
			keywords = {},
			sidebars = "transparent",
			floats = "transparent",
		},
	})
	vim.cmd("colorscheme tokyonight-night")
end

return {
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		config = config,
	},
}
