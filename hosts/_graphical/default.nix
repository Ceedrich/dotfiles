{
  selfpkgs,
  inputs',
  lib,
  pkgs,
  selfnixosmodules,
  ...
}: let
  inherit (lib) mkDefault;
in {
  imports = with selfnixosmodules; [
    clipboard
    firefox
    flatpak
    # gdm
    gtk
    hypr
    hyprland
    power-menu
    rofi
    spotify
    swaync
    vpn
    waybar
    wlr-which-key
    zathura
  ];
  config = {
    services.displayManager.cosmic-greeter.enable = true;

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

    ceedrich.standardPrograms = {
      terminal.package = selfpkgs.foot;
      browser.command = "librewolf";
      launcher.package = selfpkgs.wlr-which-key;
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
      selfpkgs.system
      blender-hip
      poppler-utils
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
    programs = {
      hyprland.enable = mkDefault true;
      hyprlock.enable = mkDefault true;
      thunderbird.enable = mkDefault true;
      zathura.enable = mkDefault true;
      firefox.enable = mkDefault true;
    };
    # environment.etc."firefox/policies/policies.json".target = "librewolf/policies/policies.json";
    services = {
      clipboard.enable = mkDefault true;
      swaync.enable = mkDefault true;
      hypridle.enable = mkDefault true;
      hyprsunset.enable = mkDefault true;
      hyprpolkitagent.enable = mkDefault true;
      tailscale.tray.enable = mkDefault true;
      playerctld.enable = mkDefault true;
      printing.enable = mkDefault true;
    };
  };
}
