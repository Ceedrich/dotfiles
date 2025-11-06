{}: rec {
  name = "battery";
  settings = {
    ${name} = {
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
}
