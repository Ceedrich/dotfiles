{
  ceedrichPkgs,
  inputs,
  lib,
  pkgs,
  pkgs-unstable,
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

      services.owncloud-client.enable = true;

      xdg.userDirs = {
        enable = true;
        createDirectories = true;
        desktop = null;
        publicShare = null;
        music = null;
      };
    };

    environment.systemPackages = with pkgs; [
      (pass.withExtensions (ext: with ext; [pass-otp pass-update pass-audit]))
      inputs.deploy-rs.packages.${pkgs.stdenv.hostPlatform.system}.deploy-rs
      signal-desktop
      vlc
      audacity
      libnotify
      ceedrichPkgs.test-icons
      blender-hip
      poppler-utils
      pkgs-unstable.hyprshutdown
      jellyfin-desktop
      wl-clipboard
      wlrctl
    ];

    logoutCommands = {
      shutdown = ''hyprctl dispatch exec "hyprshutdown -t 'Shutting down...' --post-cmd 'shutdown -P 0'"'';
      reboot = ''hyprctl dispatch exec "hyprshutdown -t 'Restarting...' --post-cmd 'reboot'"'';
      logout = ''hyprctl dispatch exec "hyprshutdown -t 'Logging out...'"'';
    };

    allowedUnfree = [
      "spotify"
    ];

    programs = {
      ghostty.enable = mkDefault true;
      hyprland.enable = mkDefault true;
      hyprlock.enable = mkDefault true;
      thunderbird.enable = mkDefault true;
      zathura.enable = mkDefault true;
      firefox.enable = mkDefault true;

      spicetify = let
        spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
      in {
        enable = true;
        theme = spicePkgs.themes.catppuccin;
        colorScheme = config.catppuccin.flavor;
      };
    };
    environment.etc."firefox/policies/policies.json".target = "librewolf/policies/policies.json";
    services = {
      clipboard.enable = mkDefault true;
      swaync.enable = mkDefault true;
      hypridle.enable = mkDefault true;
      hyprsunset.enable = mkDefault true;
      mpvpaper.enable = mkDefault true;
      tailscale.tray.enable = mkDefault true;
      playerctld.enable = mkDefault true;
      printing.enable = mkDefault true;
      cshell.enable = mkDefault true;
    };
  };
}
