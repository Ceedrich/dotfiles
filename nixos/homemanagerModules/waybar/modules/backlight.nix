{}: rec {
  name = "backlight";
  settings.${name} = {
    format = "{percent}% {icon}";
    format-icons = ["󱩎" "󱩎" "󱩏" "󱩐" "󱩑" "󱩒" "󱩓" "󱩔" "󱩕" "󱩖" "󰛨"];
    tooltip = false;
  };
  style =
    /*
    css
    */
    ''
      #${name} {
        border-bottom: 2px solid;
      }
    '';
}
