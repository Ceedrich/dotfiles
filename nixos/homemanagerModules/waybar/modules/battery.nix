{
  lib,
  config,
  ...
}: let
  wb = config.programs.waybar;
  cfg = wb.modules.battery;
in {
  options.programs.waybar.modules.battery = {
    name = lib.mkOption {
      type = lib.types.str;
      default = "battery";
      readOnly = true;
    };
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
  config.programs.waybar = lib.mkIf cfg.enable {
    settings = lib.genAttrs cfg.bars (bar: {
      "${cfg.name}" = {
        format = "{capacity}% {icon}";
        format-icons = {
          charging = ["󰢜" "󰂇" "󰢝" "󰢞" "󰂅"];
          default = ["󰁺" "󰁼" "󰁾" "󰂀" "󰂂" "󰁹"];
        };
        interval = 5;
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
        #${cfg.name}.charging {
          color: @green;
        }
        #${cfg.name}.discharging.warning {
          color: @yellow;
        }
        #${cfg.name}.discharging.critical {
          color: @red;
        }
      '';
  };
}
