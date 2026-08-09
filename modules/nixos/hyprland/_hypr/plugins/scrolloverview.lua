if hl.plugin.scrolloverview ~= nil then
  hl.bind("SUPER + g", function()
    hl.plugin.scrolloverview.overview("toggle all")
  end)
end
