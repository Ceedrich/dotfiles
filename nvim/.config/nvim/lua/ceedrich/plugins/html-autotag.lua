return {
	"windwp/nvim-ts-autotag",
	-- ft = {
	--   "javascript",
	--   "javascriptreact",
	--   "typescript",
	--   "typescriptreact",
	--   "html",
	-- },
	setup = function()
		require("nvim-ts-autotag").setup({
			opts = {
				enable_close = true,
				enable_rename = true,
				enable_close_on_slash = true,
			},
		})
	end,
}
