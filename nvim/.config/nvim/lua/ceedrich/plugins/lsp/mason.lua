return {
	"williamboman/mason.nvim",
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
	},
	config = function()
		local mason = require("mason")

		local mason_lspconfig = require("mason-lspconfig")

		local mason_tool_installer = require("mason-tool-installer")

		mason.setup({
			ui = {
				icons = {
					package_installed = "",
					package_pending = "󰜴",
					package_uninstalled = "✗",
				},
			},
		})

		mason_lspconfig.setup({
			ensure_installed = {
				"tsserver", -- Typescript
				"html", -- HTML
				"cssls", -- CSS
				"tailwindcss", -- Tailwind
				"lua_ls", -- Lua
				"emmet_ls", -- HTML, CSS
				"prismals", -- Prisma
				"clangd", -- C++
				"cmake", -- Cmake
				"rust_analyzer", -- Rust
				"bashls", -- bash
				"taplo", -- TOML
				"texlab", -- LaTeX
			},
		})

		mason_tool_installer.setup({
			ensure_installed = {
				"prettier",
				"stylua",
				"clang-format",
				"eslint_d",
			},
		})
	end,
}
