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

    xdg.userDirs = {
      enable = true;
      createDirectories = true;
      desktop = null;
      publicShare = null;
    };
  };

  environment.systemPackages = with pkgs; [
    signal-desktop
    vlc
    audacity
    ceedrichPkgs.test-icons
  ];

  programs = {
    nautilus.enable = mkDefault true;
    ghostty.enable = mkDefault true;
    hyprland.enable = mkDefault true;
    hyprlock.enable = mkDefault true;
    thunderbird.enable = mkDefault true;
    zathura.enable = mkDefault true;
  };
  services = {
    hypridle.enable = mkDefault true;
    mpvpaper.enable = mkDefault true;
    tailscale.tray.enable = mkDefault true;
    waybar.enable = mkDefault true;
  };
}
