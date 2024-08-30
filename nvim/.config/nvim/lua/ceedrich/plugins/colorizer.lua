return {
	"NvChad/nvim-colorizer.lua",
	config = function()
		require("colorizer").setup({
			filetypes = {
				"*",
				css = {
					css = true,
					css_fn = true,
				},
			},
			user_default_options = {
				names = false, -- "Name" codes like Blue or blue
				RRGGBBAA = true, -- #RRGGBBAA hex codes
				mode = "background", -- Set the display mode.
				tailwind = true, -- Enable tailwind colors
				virtualtext = "■",
				always_update = false,
			},
		})
	end,
}
