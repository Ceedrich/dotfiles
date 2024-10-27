return {
	"nvim-treesitter/nvim-treesitter",
	event = { "BufReadPre", "BufNewFile" },
	build = ":TSUpdate",
	dependencies = {
		"windwp/nvim-ts-autotag",
		"tadmccorkle/markdown.nvim",
	},
	config = function()
		local treesitter = require("nvim-treesitter.configs")

		treesitter.setup({
			highlight = {
				enable = true,
				disable = { "latex" },
			},
			markdown = { enable = true },
			indent = { enable = true },
			autotag = { enable = true },
			ensure_installed = {
				"json",
				"javascript",
				"typescript",
				"tsx",
				"yaml",
				"toml",
				"html",
				"css",
				"prisma",
				"bash",
				"lua",
				"vim",
				"dockerfile",
				"gitignore",
				"c",
				"cpp",
				"rust",
				"tmux",
				"markdown",
				"markdown_inline",
			},
		})
	end,
}
