{
  lib,
  config,
  ...
}: let
  cfg = config.settings.hyprland;
  inherit (lib) mkEnableOption mkDefault mkIf;
in {
  options.settings.hyprland = {
    enable = mkEnableOption "enable hyprland config";
  };
  imports = [
    # ./hyprland.nix
    ./hypridle
    ./hyprpaper
    ./hyprlock
    ./rofi
    ./waybar
  ];
  config = {
    wayland.windowManager.hyprland.systemd.enable = true;

    programs = mkIf cfg.enable {
      waybar.enable = mkDefault true;
      hyprlock.enable = mkDefault true;
      rofi.enable = mkDefault true;
    };
    services = {
      hyprpaper.enable = mkDefault true;
      hypridle.enable = mkDefault true;
    };
  };
}
