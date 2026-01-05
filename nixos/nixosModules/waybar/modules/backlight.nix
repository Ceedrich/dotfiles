{
  lib,
  config,
  ...
}: let
  wb = config.services.waybar;
  cfg = wb.modules.backlight;
in {
  options.services.waybar.modules.backlight = {
    enable = lib.mkOption {
      description = "enable backlight module";
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
    settings = lib.genAttrs cfg.bars (bar: {
      "backlight" = {
        format = "{percent}% {icon}";
        format-icons = ["󱩎" "󱩎" "󱩏" "󱩐" "󱩑" "󱩒" "󱩓" "󱩔" "󱩕" "󱩖" "󰛨"];
        tooltip = false;
        reverse-scrolling = true;
      };
    });

    style =
      # css
      ''
        #backlight {
          border-bottom: 2px solid;
        }
      '';
  };
}
