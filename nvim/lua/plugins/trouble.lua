return {
	{
		"folke/trouble.nvim",
		dependencies = {
			{ "nvim-tree/nvim-web-devicons" },
		},
		opts = {
			position = "right",
		},
		config = function()
			vim.keymap.set("n", "<leader>xx", function()
				require("trouble").open()
			end)
		end,
	},
}
