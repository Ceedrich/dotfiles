{
  config,
  lib,
  ...
}: let
  catppuccin = config.catppuccin;
  styleFile = "${catppuccin.sources.waybar}/${catppuccin.flavor}.css";
in {
  services.waybar.style = lib.mkBefore ''
    @import "${styleFile}"
  '';
}
