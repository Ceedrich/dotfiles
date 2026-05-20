{
  self,
  inputs,
  ...
}: {
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

    catppuccin.kvantum.enable = false;

    home.packages = [
      pkgs.catppuccin-qt5ct
    ];
    qt = let
      ccfg = config.catppuccin;
      settings = {
        Appearance = {
          custom_palette = true;
          color_scheme_path = "${pkgs.catppuccin-qt5ct}/share/qt5ct/colors/catppuccin-${ccfg.flavor}-${ccfg.accent}.conf";
        };
      };
    in {
      enable = true;
      platformTheme.name = "qtct";
      qt5ctSettings = settings;
      qt6ctSettings = settings;
    };
  };
}
