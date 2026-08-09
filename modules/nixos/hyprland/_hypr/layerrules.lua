hl.layer_rule({ match = { namespace = "^cshell.*" }, no_anim = true })
hl.layer_rule({ match = { namespace = "^rofi$" }, no_anim = true })

hl.window_rule({ match = { class = "^foot$" }, opacity = "0.7 0.6" })
hl.window_rule({ match = { class = ".*" }, suppress_event = "maximize" })

hl.window_rule({
	match = {
		class = "[Xx]dg-desktop-portal-[a-zA-z0-9]*",
	},
	float = true,
	center = true,
})

for _, regex in ipairs({
	"^Open File$",
	"^Open$",
	"^Save$",
	"^Save File$",
	"^Save As$",
	"^Export$",
	"^Picture-in-Picture$",
	"^Import$",
	"^Choose File$",
	"^Rename$",
	"^This page wants to save$",
	"org.pulseaudio.pavucontrol",
	".blueman-manager-wrapped",
	"nm-connection-editor",
}) do
	hl.window_rule({
		match = {
			title = regex,
		},
		float = true,
	})
end
