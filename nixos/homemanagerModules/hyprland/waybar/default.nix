{ lib, config, ... }:

{
  options = {
    waybar.enable = lib.mkEnableOption "enable waybar";
    waybar.modules = {
      audio = lib.mkEnableOption "enable audio module";
      clock = lib.mkEnableOption "enable clock module";
      tray = lib.mkEnableOption "enable tray module";
    };
  };
  config =
    let
      wb = config.waybar;
      m = wb.modules;
      audio = m.audio.enable;
      tray = m.tray.enable;
      clock = m.clock.enable;
      inherit (lib) mkIf;
    in
    mkIf wb.enable {
      programs.waybar = {
        enable = true;
        style = lib.readFile ./style.css;
        settings = {
          position = "top";
          modules-left = [ "hyprland/workspces" ];
          modules-center = [ "hyprland/window" ];
          modules-right = [
            (mkIf audio "pulseaudio")
            (mkIf tray "tray")
            (mkIf clock "clock")
          ];

          pulseaudio = mkIf audio {
            format = "{volume}% {icon}";
            format-bluetooth = "{volume}% {icon}";
            format-muted = "{volume}% 󰝟";
            format-icons.default = [ "󰖀" "󰕾" ];
            scroll-step = 3;
            on-click = "wpctl set-mute @DEFAULT_SINK@ toggle";
          };

          tray = mkIf tray {
            icon-size = 21;
            spacing = 10;
          };

          clock = mkIf clock {
            format = "  {:%a %d %H:%M}";
            tooltip-format = "<tt><small>{calendar}</small></tt>";
          };
        };
      };
    };
}
