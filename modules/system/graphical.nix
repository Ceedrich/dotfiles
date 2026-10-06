{
  self,
  moduleWithSystem,
  lib,
  ...
}: {
  flake.nixosModules.system-graphical = moduleWithSystem ({self', ...}: {
    inputs',
    pkgs,
    ...
  }: let
    inherit (lib) mkDefault;
  in {
    imports = with self.nixosModules; [
      clipboard
      firefox
      flatpak
      gdm
      gtk
      hypr-cshell
      ly
      power-menu
      rofi
      spotify
      vpn
      wlr-which-key
      zathura
    ];
    config = {
      home-manager.sharedModules = [
        {
          programs.brave.enable = true;
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

      services.udisks2.enable = true;

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
        terminal.package = self'.packages.foot;
        browser.command = "librewolf";
        launcher.package = self'.packages.wlr-which-key;
      };

      environment.systemPackages = with pkgs; [
        brightnessctl
        (pass.withExtensions (ext: with ext; [pass-otp pass-update pass-audit]))
        inputs'.deploy-rs.packages.deploy-rs
        signal-desktop
        vlc
        audacity
        libnotify
        blender
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
        playerctl
        pavucontrol

        gimp
        nautilus

        # libreoffice
        libreoffice-qt
        hunspell
        hunspellDicts.de-ch
        hunspellDicts.fr-moderne
        hunspellDicts.en-us

        self'.packages.test-icons
        self'.packages.system
        self'.packages.open
        self'.packages.pdfcat
      ];
      programs = {
        hyprland.enable = mkDefault true;
        thunderbird.enable = mkDefault true;
        zathura.enable = mkDefault true;
        firefox.enable = mkDefault true;
      };
      # environment.etc."firefox/policies/policies.json".target = "librewolf/policies/policies.json";
      services = {
        tailscale.tray.enable = mkDefault true;
        printing.enable = mkDefault true;
      };
    };
  });
}
