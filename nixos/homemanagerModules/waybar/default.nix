{
  lib,
  config,
  ...
}: {
  imports = [
    ./modules/audio.nix
    ./modules/backlight.nix
    ./modules/battery.nix
    ./modules/clock.nix
    ./modules/idle_inhibitor.nix
    ./modules/player.nix
    ./modules/powermenu.nix
    ./modules/tray.nix
    ./modules/window.nix
    ./modules/workspaces.nix
  ];
  options.programs.waybar = {
    enableSwaySupport = lib.mkEnableOption "enable Sway support";
    enableHyprlandSupport = lib.mkEnableOption "enable Hyprland support";
  };
  config = let
    inherit (lib) mkIf;
    wb = config.programs.waybar;
    m = wb.modules;
  in {
    programs.waybar = mkIf wb.enable {
      style = builtins.readFile ./style.css;
      settings.mainBar = {
        position = "top";
        modules-left = [
          (mkIf m.clock.enable "clock")
          # Window
          (mkIf wb.enableSwaySupport "sway/window")
          (mkIf wb.enableHyprlandSupport "hyprland/window")
        ];
        modules-center = [
          # (mkIf m.player.enable "group/music-player")
        ];
        modules-right = [
          # Workspaces
          (mkIf wb.enableSwaySupport "sway/workspaces")
          (mkIf wb.enableHyprlandSupport "hyprland/workspaces")

          (mkIf m.audio.enable "pulseaudio")
          (mkIf m.battery.enable "battery")
          (mkIf m.backlight.enable "backlight")
          (mkIf m.idle_inhibitor.enable "idle_inhibitor")
          (mkIf m.powermenu.enable "group/powermenu")
          (mkIf m.tray.enable "tray")
        ];
      };
    };
  };
}
