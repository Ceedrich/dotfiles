{
  lib,
  config,
  ...
}: let
  wb = config.programs.waybar;
  cfg = wb.modules.window;
  windowConfig = {
    format = "{title}";
    max-length = 30;
  };
in {
  options.programs.waybar.modules.window = {
    name = lib.mkOption {
      type = lib.types.str;
      default = "hyprland/window";
      readOnly = true;
    };
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
  config.programs.waybar = lib.mkIf cfg.enable {
    settings = lib.attrsets.genAttrs cfg.bars (bar: {
      ${cfg.name} = windowConfig;
    });
  };
}
