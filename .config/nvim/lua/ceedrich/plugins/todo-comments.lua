return {
	"folke/todo-comments.nvim",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = { "nvim-lua/plenary.nvim" },

	opts = {
		keywords = {
			ERROR = {
				icon = "",
				color = "error",
			},
		},
		highlight = {
			pattern = [[.*<(KEYWORDS)\s*]],
		},
	},
}
