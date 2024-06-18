return {
	"catppuccin/nvim",
	name = "catppuccin",
	lazy = false,
	priority = 1000,
	config = function()
		vim.o.background = "dark"
		require("catppuccin").setup({
			flavour = "mocha",
			dim_inactive = {
				enabled = true, -- dims the background color of inactive window
				shade = "dark",
				percentage = 0.15, -- percentage of the shade to apply to the inactive window
			},
		})
		vim.cmd("colorscheme catppuccin")
	end,
}
