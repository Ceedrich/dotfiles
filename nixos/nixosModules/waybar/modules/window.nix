{
  lib,
  config,
  ...
}: let
  wb = config.services.waybar;
  cfg = wb.modules.window;
  windowConfig = {
    format = "{title}";
    max-length = 30;
  };
in {
  options.services.waybar.modules.window = {
    enable = lib.mkOption {
      description = "enable window module";
      default = true;
      type = lib.types.bool;
    };
    bars = lib.mkOption {
      default = [wb.mainBar];
      type = lib.types.listOf lib.types.str;
      description = "The names of the bars to add the module to";
    };
  };
  config.services.waybar = lib.mkIf cfg.enable {
    settings = lib.attrsets.genAttrs cfg.bars (bar: {
      "hyprland/window" = lib.mkIf wb.enableHyprlandSupport windowConfig;
      "sway/window" = lib.mkIf wb.enableSwaySupport windowConfig;
    });
  };
}
