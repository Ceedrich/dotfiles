if hl.plugin.scrolloverview ~= nil then
  hl.config({
    plugin = {
      scrolloverview = {
        gesture_distance = 300, -- how far is the "max" for the gesture
        scale = 0.8,        -- preferred overview scale
        workspace_gap = 30,
        layout = "horizontal", -- vertical or horizontal
        wallpaper = 0,      -- 0: global only, 1: per-workspace only, 2: both
        blur = true,        -- blur only the main overview wallpaper

        shadow = {
          enabled = false,
        },
      },
    },
  })

  hl.bind("SUPER + g", function()
    hl.plugin.scrolloverview.overview("toggle all")
  end)
end
