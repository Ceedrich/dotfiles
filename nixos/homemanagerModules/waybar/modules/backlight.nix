{lib, ...}: {
  options.programs.waybar.modules.backlight = {
    enable = lib.mkOption {
      description = "enable backlight module";
      default = true;
      type = lib.types.bool;
    };
  };
  config.programs.waybar = {
    settings.mainBar."backlight" = {
      format = "{percent}% {icon}";
      format-icons = ["󱩎" "󱩎" "󱩏" "󱩐" "󱩑" "󱩒" "󱩓" "󱩔" "󱩕" "󱩖" "󰛨"];
      tooltip = false;
    };
    style =
      # css
      ''
        #backlight {
          border-bottom: 2px solid;
        }
      '';
  };
}
