-- hl.config({
-- 	plugin = {
-- 		hyprbars = {
-- 			bar_height = 28,
-- 			bar_button_padding = 8,
-- 			bar_blur = true,
-- 			bar_color = "$crust",
-- 			col = { text = "$overlay0" },
-- 			bar_text_size = 14,
-- 			bar_text_font = "JetBrains Mono Nerdfont",
-- 			bar_part_of_window = true,
-- 			bar_precedence_over_border = true,
-- 			bar_buttons_alignment = "left",
-- 		},
-- 	},
-- })
--
-- local function addBtn(bg_color, action)
-- 	hl.plugin.hyprbars.add_button({
-- 		size = 14,
-- 		bg_color,
-- 		action,
-- 	})
-- end
--
-- addBtn("$red", hl.notification.create({ text = "hello there", timeout = 5000 }))

hl.config({
    plugin = {
        hyprbars = {
            bar_height = 20,
            on_double_click = "hyprctl dispatch fullscreen 1",
        },
    },
})

hl.plugin.hyprbars.add_button({
    bg_color = "rgb(ff4040)",
    fg_color = "rgb(ffffff)",
    size = 10,
    icon = "X",
    action = "hyprctl dispatch killactive",
})

hl.plugin.hyprbars.add_button({
    bg_color = "rgb(eeee11)",
    fg_color = "rgb(000000)",
    size = 10,
    icon = "_",
    action = "hyprctl dispatch fullscreen 1",
})
