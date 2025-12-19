{lib, ...}: let
  inherit (lib) mkDefault;
in {
  programs.ghostty.enable = mkDefault true;
  programs.hyprland.enable = mkDefault true;
  programs.hyprlock.enable = mkDefault true;

  services.hypridle.enable = mkDefault true;
  services.waybar.enable = mkDefault true;
}
