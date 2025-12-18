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
    ./rofi
  ];

  config = {
    programs = mkIf cfg.enable {
      rofi.enable = mkDefault true;
    };
  };
}
