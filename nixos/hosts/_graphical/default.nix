{
  ceedrichPkgs,
  inputs,
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib) mkDefault;
in {
  imports = [
    inputs.spicetify-nix.nixosModules.default
  ];
  config = {
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
      libnotify
      ceedrichPkgs.test-icons
    ];

    allowedUnfree = [
      "spotify"
    ];

    programs = {
      ghostty.enable = mkDefault true;
      hyprland.enable = mkDefault true;
      hyprlock.enable = mkDefault true;
      thunderbird.enable = mkDefault true;
      zathura.enable = mkDefault true;
      spicetify = let
        spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
      in {
        enable = true;
        theme = spicePkgs.themes.catppuccin;
        colorScheme = config.catppuccin.flavor;
      };
    };
    services = {
      swaync.enable = mkDefault true;
      hypridle.enable = mkDefault true;
      mpvpaper.enable = mkDefault true;
      tailscale.tray.enable = mkDefault true;
      playerctld.enable = mkDefault true;
    };
  };
}
