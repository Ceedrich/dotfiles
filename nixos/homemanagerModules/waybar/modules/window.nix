{
  lib,
  config,
  ...
}: let
  cfg = config.programs.waybar;
  m = cfg.modules;
  windowConfig = {
    format = "{title}";
    max-length = 30;
  };
in {
  options.programs.waybar.modules.window = lib.mkOption {
    description = "enable window module";
    default = true;
    type = lib.types.bool;
  };
  config.programs.waybar = lib.mkIf m.window {
    settings.mainBar = {
      "hyprland/window" = lib.mkIf cfg.enableHyprlandSupport windowConfig;
      "sway/window" = lib.mkIf cfg.enableSwaySupport windowConfig;
    };
  };
}
