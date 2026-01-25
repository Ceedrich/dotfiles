{
  ceedrichPkgs,
  inputs,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkDefault;
in {
  global-hm.config = {
    programs.brave.enable = true;
    programs.nwg-drawer.enable = true;
    xdg.mimeApps.defaultApplications = {
      "text/html" = "brave-browser.desktop";
      "x-scheme-handler/http" = "brave-browser.desktop";
      "x-scheme-handler/https" = "brave-browser.desktop";
      "x-scheme-handler/about" = "brave-browser.desktop";
      "x-scheme-handler/unknown" = "brave-browser.desktop";
    };
    programs.waybar = {
      enable = mkDefault true;
      modules = {
        window.enable = false;
        player.enable = false;
      };
    };
    vpn.epfl = true;

    xdg.userDirs = {
      enable = true;
      createDirectories = true;
      desktop = null;
      publicShare = null;
      music = null;
    };
  };

  environment.systemPackages = with pkgs; [
    inputs.deploy-rs.packages.${pkgs.stdenv.hostPlatform.system}.deploy-rs
    signal-desktop
    vlc
    audacity
    ceedrichPkgs.test-icons
  ];

  programs = {
    ghostty.enable = mkDefault true;
    hyprland.enable = mkDefault true;
    hyprlock.enable = mkDefault true;
    thunderbird.enable = mkDefault true;
    zathura.enable = mkDefault true;
  };
  services = {
    swaync.enable = mkDefault true;
    hypridle.enable = mkDefault true;
    mpvpaper.enable = mkDefault true;
    tailscale.tray.enable = mkDefault true;
  };
}
