require("globals")

local mod = GLOBALS.mainMod

local function andTop(dsp)
	return function()
		hl.dispatch(dsp)
		hl.dispatch(hl.dsp.window.alter_zorder({ mode = "top" }))
	end
end

hl.bind(mod .. " + Q", hl.dsp.window.close())
hl.bind(mod .. " + T", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mod .. " + F", hl.dsp.window.fullscreen({ action = "toggle" }))

-- Window movement
hl.bind(mod .. " + H", andTop(hl.dsp.focus({ direction = "left" })))
hl.bind(mod .. " + J", andTop(hl.dsp.focus({ direction = "down" })))
hl.bind(mod .. " + K", andTop(hl.dsp.focus({ direction = "up" })))
hl.bind(mod .. " + L", andTop(hl.dsp.focus({ direction = "right" })))

hl.bind(mod .. " + SHIFT + H", andTop(hl.dsp.window.move({ direction = "left" })))
hl.bind(mod .. " + SHIFT + J", andTop(hl.dsp.window.move({ direction = "down" })))
hl.bind(mod .. " + SHIFT + K", andTop(hl.dsp.window.move({ direction = "up" })))
hl.bind(mod .. " + SHIFT + L", andTop(hl.dsp.window.move({ direction = "right" })))

hl.bind(mod .. " + TAB", andTop(hl.dsp.window.cycle_next({ next = true })))
hl.bind(mod .. " + SHIFT + TAB", andTop(hl.dsp.window.cycle_next({ next = false })))

-- CShell
hl.bind(mod .. " + N", hl.dsp.exec_cmd("cshell ipc call control-center toggle"))

-- Programms
hl.bind(mod .. " + B", hl.dsp.exec_cmd("librewolf"))
hl.bind(mod .. " + RETURN", hl.dsp.exec_cmd("foot"))
hl.bind(mod .. " + SPACE", hl.dsp.exec_cmd("wlr-which-key"))

for i = 1, 9, 1 do
	hl.bind(mod .. " + " .. i, hl.dsp.focus({ workspace = i }))
	hl.bind(mod .. " + SHIFT + " .. i, hl.dsp.window.move({ workspace = i }))
end

-- Misc
hl.bind("PRINT", hl.dsp.exec_cmd("hyprshot -o /home/ceedrich/Pictures/Screenshots -m region"))
hl.bind(mod .. " + S", hl.dsp.exec_cmd("hyprshot -o /home/ceedrich/Pictures/Screenshots -m region"))
hl.bind("SHIFT + PRINT", hl.dsp.exec_cmd("hyprshot -o /home/ceedrich/Pictures/Screenshots -m window"))
hl.bind(mod .. " + SHIFT + S", hl.dsp.exec_cmd("hyprshot -o /home/ceedrich/Pictures/Screenshots -m window"))

-- Laptop buttons
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), {
	locked = true,
	repeating = true,
})
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+"), {
	locked = true,
	repeating = true,
})
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume -l 0.0 @DEFAULT_AUDIO_SINK@ 5%-"), {
	locked = true,
	repeating = true,
})
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -q s 10%-"), {
	locked = true,
	repeating = true,
})
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -q s +10%"), {
	locked = true,
	repeating = true,
})

-- Mouse
hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
