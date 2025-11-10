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
        color: @mauve;
        border-bottom: 2px solid @mauve;
      }
      #battery.charging {
        color: @green;
        border-bottom: 2px solid @green;
      }
      #battery.discharging.warning {
        color: @yellow;
        border-bottom: 2px solid @yellow;
      }
      #battery.discharging.critical {
        color: @red;
        border-bottom: 2px solid @red;
      }
    '';
}
