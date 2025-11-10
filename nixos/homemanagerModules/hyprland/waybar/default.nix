{
  pkgs,
  lib,
  config,
  ...
}: {
  options.programs.waybar.modules = {
    audio = lib.mkEnableOption "enable audio module";
    clock = lib.mkEnableOption "enable clock module";
    date = lib.mkEnableOption "enable date module";
    tray = lib.mkEnableOption "enable tray module";
    powermenu = lib.mkEnableOption "enable powermenu";
    battery = lib.mkEnableOption "enable battery";
  };
  config = let
    inherit (lib) mkIf;
    wb = config.programs.waybar;
    m = wb.modules;

    powermenu-name = "group/powermenu";
  in {
    programs.waybar = mkIf wb.enable {
      modules = {
        audio = lib.mkDefault true;
        clock = lib.mkDefault true;
        date = lib.mkDefault true;
        tray = lib.mkDefault true;
        powermenu = lib.mkDefault true;
        battery = lib.mkDefault true;
      };
      style = lib.readFile ./style.css;
      settings.mainBar =
        {
          position = "top";
          modules-left = [
            (mkIf m.date "clock#date")
            "hyprland/window"
          ];
          modules-center = [
            (mkIf m.clock "clock")
          ];
          modules-right = [
            "hyprland/workspaces"
            (mkIf m.audio "pulseaudio")
            (mkIf m.battery "battery")
            (mkIf m.powermenu powermenu-name)
            (mkIf m.tray "tray")
          ];

          pulseaudio = mkIf m.audio {
            format = "{volume}% {icon}";
            format-bluetooth = "{volume}% {icon}";
            format-muted = "{volume}% 󰝟";
            format-icons.default = ["󰖀" "󰕾"];
            scroll-step = 3;
            on-click = "wpctl set-mute @DEFAULT_SINK@ toggle";
            on-click-right = lib.getExe (pkgs.pavucontrol);
          };
          clock = mkIf m.clock {
            tooltip = false;
            format = "{:%H:%M}";
            format-alt = "{:%a %d.%m.%Y %H:%M:%S}";
            interval = 1;
          };
          "clock#date" = mkIf m.date {
            format = "{:%d.%m.}";
            tooltip = false;
          };

          tray = mkIf m.tray {
            icon-size = 21;
            spacing = 10;
          };

          battery = mkIf m.battery {
            interval = 10; # WARN: remove
            format = "{capacity}% {icon}";
            format-icons = {
              charging = ["󰢜" "󰂇" "󰢝" "󰢞" "󰂅"];
              default = ["󰁺" "󰁼" "󰁾" "󰂀" "󰂂" "󰁹"];
            };
            states = {
              thirty = 30;
              warning = 30;
              critical = 15;
            };
          };
        }
        // (import ./modules/powermenu.nix {
          inherit pkgs;
          name = powermenu-name;
        });
    };
  };
}
