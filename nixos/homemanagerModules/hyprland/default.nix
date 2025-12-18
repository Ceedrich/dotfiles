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
    ./hyprpaper
    ./hyprlock
    ./rofi
  ];

  config = {
    programs = mkIf cfg.enable {
      hyprlock.enable = mkDefault true;
      rofi.enable = mkDefault true;
    };
    services = {
      hyprpaper.enable = mkDefault true;
    };
  };
}
