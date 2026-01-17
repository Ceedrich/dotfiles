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

  networking.networkmanager.ensureProfiles.profiles.VPN-EPFL = {
    connection = {
      id = "VPN-EPFL";
      type = "vpn";
      autoconnect = false;
    };
    vpn = {
      username = "cedric.lehr@epfl.ch";
      gateway = "vpn.epfl.ch";

      service-type = "org.freedesktop.NetworkManager.openconnect";
      protocol = "anyconnect";
      useragent = "AnyConnect";
      authtype = "password";
    };
  };

  programs = {
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
