return {
	{
		"mrcjkb/rustaceanvim",
		version = "^5", -- Recommended
		lazy = false, -- This plugin is already lazy
		-- config = function()
		-- 	local mason_registry = require("mason-registry")
		-- 	local codelldb = mason_registry.get_package("codelldb")
		-- 	local extension_path = codelldb:get_install_path() .. "/extension/"
		-- 	local codelldb_path = extension_path .. "adapter/codelldb"
		-- 	local liblldb_path = extension_path .. "lldb/lib/liblldb.so"
		-- 	local cfg = require("rustaceanvim.config")
		--
		-- 	vim.g.rustaceanvim = {
		-- 		dap = {
		-- 			adapter = cfg.get_codelldb_adapter(codelldb_path, liblldb_path),
		-- 		},
		-- 	}
		-- end,
	},
	{
		"saecki/crates.nvim",
		event = { "BufRead Cargo.toml" },
		config = function()
			require("crates").setup({
				lsp = {
					enabled = true,
					actions = true,
					completion = true,
					hover = true,
				},
			})
		end,
	},
}
