return {
	"goolord/alpha-nvim",
	event = "VimEnter",
	config = function()
		local alpha = require("alpha")
		local dashboard = require("alpha.themes.dashboard")

		-- Set header
		dashboard.section.header.val = {
			" ██████╗███████╗███████╗██████╗ ██████╗ ██╗ ██████╗██╗  ██╗",
			"██╔════╝██╔════╝██╔════╝██╔══██╗██╔══██╗██║██╔════╝██║  ██║",
			"██║     █████╗  █████╗  ██║  ██║██████╔╝██║██║     ███████║",
			"██║     ██╔══╝  ██╔══╝  ██║  ██║██╔══██╗██║██║     ██╔══██║",
			"╚██████╗███████╗███████╗██████╔╝██║  ██║██║╚██████╗██║  ██║",
			" ╚═════╝╚══════╝╚══════╝╚═════╝ ╚═╝  ╚═╝╚═╝ ╚═════╝╚═╝  ╚═╝",
		}

		dashboard.section.buttons.val = {
			dashboard.button("e", "󰈔 > New File", "<cmd>ene<CR>"),
			dashboard.button("󱁐 ee", " > Toggle File Explorer", "<cmd>NvimTreeToggle<CR>"),
			dashboard.button("󱁐 ff", "󰱼 > Search File", "<cmd>Telescope find_files<CR>"),
			dashboard.button("󱁐 fs", " > Search Text", "<cmd>Telescope live_grep<CR>"),
			dashboard.button("q", "󰅖 > Close Neovim", "<cmd>qa<CR>"),
		}

		alpha.setup(dashboard.opts)

		vim.cmd([[autocmd FileType alpha setlocal nofoldenable]])
	end,
}
