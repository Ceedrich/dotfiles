{self, ...}: {
  flake.nixosModules.gtk = {...}: {
    environment.sessionVariables = {
      GTK_IM_MODULE = "gtk-im-context-simple";
    };
    home-manager.sharedModules = with self.homeModules; [
      gtk
    ];
  };

  flake.homeModules.gtk = {
    config,
    pkgs,
    ...
  }: {
    gtk = let
      dark-theme = "gtk-application-prefer-dark-theme";
      inherit (config.catppuccin) flavor accent;

      theme = {
        name = "catppuccin-${flavor}-${accent}-standard";
        package = pkgs.catppuccin-gtk.override {
          variant = flavor;
          accents = [accent];
        };
      };
    in {
      enable = true;
      inherit theme;
      gtk3 = {
        inherit theme;
        extraConfig = {
          ${dark-theme} = 1;
        };
      };
      gtk4 = {
        inherit theme;
        extraConfig = {
          ${dark-theme} = 1;
        };
      };
    };

    qt = {
      enable = true;
      style.name = "kvantum";
      platformTheme.name = "kvantum";
    };
  };
}
