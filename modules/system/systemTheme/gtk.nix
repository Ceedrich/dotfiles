{config, ...}: {
  flake.nixosModules.gtk = {pkgs, ...}: let
    cfg = config.flake.catppuccin;
  in {
    environment.systemPackages = [
      (pkgs.catppuccin-gtk.override {
        variant = cfg.flavor;
        size = "compact";
        tweaks = ["rimless"];
        accents = [cfg.accent];
      })
      (pkgs.catppuccin-papirus-folders.override {
        flavor = cfg.flavor;
        accent = cfg.accent;
      })
      pkgs.nwg-look
    ];
    programs = {
      xfconf.enable = true;
      dconf = {
        enable = true;
        profiles.user.databases = [
          {
            lockAll = false;
            settings = {
              "org/gnome/desktop/interface" = {
                gtk-theme = "catppuccin-${cfg.flavor}-${cfg.accent}-compact+rimless";
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
