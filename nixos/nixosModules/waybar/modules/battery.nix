{
  lib,
  config,
  ...
}: let
  wb = config.services.waybar;
  cfg = wb.modules.battery;
in {
  options.services.waybar.modules.battery = {
    enable = lib.mkOption {
      description = "enable battery module";
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
      "battery" = {
        format = "{capacity}% {icon}";
        format-icons = {
          charging = ["󰢜" "󰂇" "󰢝" "󰢞" "󰂅"];
          default = ["󰁺" "󰁼" "󰁾" "󰂀" "󰂂" "󰁹"];
        };
        states = {
          warning = 30;
          critical = 15;
        };
        tooltip = true;
        tooltip-format = "{timeTo}";
      };
    });
    style =
      #css
      ''
        #battery {
          border-bottom: 2px solid;
        }
        #battery.charging {
          color: @green;
        }
        #battery.discharging.warning {
          color: @yellow;
        }
        #battery.discharging.critical {
          color: @red;
        }
      '';
  };
}
