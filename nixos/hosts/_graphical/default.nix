{
  pkgs,
  ceedrichPkgs,
  lib,
  ...
}: let
  inherit (lib) mkDefault;
in {
  global-hm.config = {
    programs.brave.enable = true;
    vpn.epfl = true;
  };

  environment.systemPackages =
    (with pkgs; [
      signal-desktop
      vlc
      audacity
    ])
    ++ (with ceedrichPkgs; [
      test-icons
    ]);

  programs.ghostty.enable = mkDefault true;
  programs.hyprland.enable = mkDefault true;
  programs.hyprlock.enable = mkDefault true;

  services.hypridle.enable = mkDefault true;
  services.waybar.enable = mkDefault true;
}
