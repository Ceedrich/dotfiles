local colors = require("themes.catppuccin")

if hl.plugin.hyprbars ~= nil then
	hl.config({
		plugin = {
			hyprbars = {
				bar_height = 28,
				bar_button_padding = 8,
				bar_blur = true,
				bar_color = colors.crust,
				col = { text = colors.overlay2 },
				bar_text_size = 14,
				bar_text_font = "JetBrains Mono Nerdfont",
				bar_part_of_window = true,
				bar_precedence_over_border = true,
				bar_buttons_alignment = "left",
			},
		},
	})

	local function addBtn(bg_color, action)
		hl.plugin.hyprbars.add_button({
			size = 14,
			bg_color = bg_color,
			fg_color = colors.text,
			action = action,
		})
	end

	addBtn(colors.red, hl.notification.create({ text = colors.red, timeout = 5000 }))
end
