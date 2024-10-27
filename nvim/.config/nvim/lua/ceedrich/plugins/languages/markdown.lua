return {
	{
		"toppair/peek.nvim",
		event = { "VeryLazy" },
		build = "deno task --quiet build:fast",
		config = function()
			local peek = require("peek")
			peek.setup()

			vim.api.nvim_create_user_command("PeekOpen", peek.open, {})
			vim.api.nvim_create_user_command("PeekClose", peek.close, {})

			local keymap = vim.keymap
			keymap.set("n", "<leader>po", peek.open, { desc = "Open markdown preview" })
			keymap.set("n", "<leader>pc", peek.close, { desc = "Close markdown preview" })
		end,
	},
	{
		"jghauser/follow-md-links.nvim",
	},
	{
		"MeanderingProgrammer/render-markdown.nvim",
		opts = {},
		dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" }, -- if you prefer nvim-web-devicons
	},
}
