if hl.plugin.scrolloverview ~= nil then
	hl.config({
		plugin = {
			scrolloverview = {
				gesture_distance = 20, -- how far is the "max" for the gesture
				scale = 0.8, -- preferred overview scale
				workspace_gap = 30,
				layout = "horizontal", -- vertical or horizontal
				wallpaper = 0, -- 0: global only, 1: per-workspace only, 2: both
				blur = false, -- blur only the main overview wallpaper
			},
		},
	})

	hl.bind("SUPER + g", function()
		hl.plugin.scrolloverview.overview("toggle all")
	end)

	hl.plugin.scrolloverview.gesture({ fingers = 3, direction = "vertical", action = "overview" })
	hl.plugin.scrolloverview.gesture({ fingers = 3, direction = "vertical", action = "unset" })
end
