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
    xdg.mimeApps.defaultApplications = {
      "text/html" = "brave-browser.desktop";
      "x-scheme-handler/http" = "brave-browser.desktop";
      "x-scheme-handler/https" = "brave-browser.desktop";
      "x-scheme-handler/about" = "brave-browser.desktop";
      "x-scheme-handler/unknown" = "brave-browser.desktop";
    };
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
  services.tailscale.tray.enable = mkDefault true;
}
