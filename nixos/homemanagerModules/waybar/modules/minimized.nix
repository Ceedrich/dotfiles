{
  lib,
  config,
  ...
}: let
  wb = config.programs.waybar;
  cfg = wb.modules.minimized;
in {
  options.programs.waybar.modules.minimized = {
    name = lib.mkOption {
      type = lib.types.str;
      default = "custom/minimized";
      readOnly = true;
    };
    enable = lib.mkOption {
      description = "minimized";
      default = true;
      type = lib.types.bool;
    };
    bars = lib.mkOption {
      default = [wb.mainBar];
      type = lib.types.listOf lib.types.str;
      description = "The names of the bars to add the module to";
    };
  };
  config.programs.waybar = {
    settings = let
      hyprlandPackage = config.wayland.windowManager.hyprland.package;
    in
      lib.genAttrs cfg.bars (bar: {
        "${cfg.name}" = {
          "format" = "󰖯";
          "tooltip-format" = "Minimized windows";
          "on-click" = "${hyprlandPackage}/bin/hyprctl dispatch plugin:xtd:bringallfrom special:minimized";
        };
      });
  };
}
