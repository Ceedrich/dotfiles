{lib, ...}: {
  options.programs.waybar.modules.battery = {
    enable = lib.mkOption {
      description = "enable battery module";
      default = true;
      type = lib.types.bool;
    };
  };
  config.programs.waybar = {
    settings.mainBar = {
      "battery" = {
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
    };
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
