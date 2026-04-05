{
  selfpkgs,
  inputs,
  inputs',
  lib,
  pkgs,
  config,
  selfnixosmodules,
  ...
}: let
  inherit (lib) mkDefault;
in {
  imports = [
    inputs.spicetify-nix.nixosModules.default
    selfnixosmodules.gdm
  ];
  config = {
    home-manager.sharedModules = [
      {
        programs.brave.enable = true;
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
      }
    ];

    xdg.mime.defaultApplications = let
      browser = "librewolf.desktop";
    in {
      "text/html" = browser;
      "x-scheme-handler/http" = browser;
      "x-scheme-handler/https" = browser;
      "x-scheme-handler/about" = browser;
      "x-scheme-handler/unknown" = browser;
      "image/*" = "qimgv.desktop";
    };

    environment.systemPackages = with pkgs; [
      brightnessctl
      (pass.withExtensions (ext: with ext; [pass-otp pass-update pass-audit]))
      inputs'.deploy-rs.packages.deploy-rs
      signal-desktop
      vlc
      audacity
      libnotify
      selfpkgs.test-icons
      selfpkgs.launcher
      selfpkgs.system
      blender-hip
      poppler-utils
      hyprshutdown
      jellyfin-desktop
      wl-clipboard
      wlrctl
      qimgv
      imagemagick
      keepassxc
      gh
      nsxiv
      inkscape

      # libreoffice
      libreoffice-qt
      hunspell
      hunspellDicts.de-ch
      hunspellDicts.fr-moderne
      hunspellDicts.en-us
    ];
    allowedUnfree = [
      "spotify"
    ];

    logoutCommands = {
      shutdown = ''hyprctl dispatch exec "hyprshutdown -t 'Shutting down...' --post-cmd 'systemctl poweroff'"'';
      reboot = ''hyprctl dispatch exec "hyprshutdown -t 'Restarting...' --post-cmd 'reboot'"'';
      logout = ''hyprctl dispatch exec "hyprshutdown -t 'Logging out...'"'';
    };

    programs = {
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
    # environment.etc."firefox/policies/policies.json".target = "librewolf/policies/policies.json";
    services = {
      clipboard.enable = mkDefault true;
      swaync.enable = mkDefault true;
      hypridle.enable = mkDefault true;
      hyprsunset.enable = mkDefault true;
      tailscale.tray.enable = mkDefault true;
      playerctld.enable = mkDefault true;
      printing.enable = mkDefault true;
    };

    services.flatpak = {
      enable = true;
      update.auto.enable = true;
      packages = [
        "com.modrinth.ModrinthApp"
      ];
    };
    environment.profileRelativeEnvVars = {
      XDG_DATA_DIRS = ["/var/lib/flatpak/exports/share"];
    };

    nix.settings = {
      substituters = ["https://hyprland.cachix.org"];
      trusted-substituters = ["https://hyprland.cachix.org"];
      trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
    };
  };
}
