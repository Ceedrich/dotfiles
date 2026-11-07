{config, ...}: {
  flake.nixosModules.gtk = {pkgs, ...}: let
    cfg = config.flake.catppuccin;
  in {
    environment.systemPackages = [
      (pkgs.catppuccin-gtk.override {
        variant = cfg.flavor;
        accents = [cfg.accent];
      })
      (pkgs.catppuccin-papirus-folders.override {
        flavor = cfg.flavor;
        accent = cfg.accent;
      })
    ];
    programs = {
      dconf = {
        enable = true;
        profiles.
          # A "user" profile with a database
          user.databases = [
          {
            lockAll = false;
            settings = {
              "org/gnome/desktop/interface" = {
                gtk-theme = "catppuccin-${cfg.flavor}-${cfg.accent}-standard";
                icon-theme = "Papirus";
                color-scheme = "prefer-dark";
              };
            };
          }
        ];
      };
    };
  };
}
