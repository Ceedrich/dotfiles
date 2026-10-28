{
  flake.nixosModules.gtk = {
    pkgs,
    lib,
    config,
    ...
  }: let
    inherit (config.catppuccin) flavor accent;
  in {
    environment.sessionVariables = {
      GTK_IM_MODULE = "gtk-im-context-simple";
    };
    environment.systemPackages = [
      (pkgs.catppuccin-gtk.override {
        variant = flavor;
        accents = [accent];
      })
    ];
    environment.etc = let
      gtkconfig = ''
        [Settings]
        gtk-application-prefer-dark-theme=1
        gtk-icon-theme-name=Papirus-Dark
        gtk-theme-name=catppuccin-${flavor}-${accent}-standard
      '';
    in
      lib.genAttrs [
        "gtk-3.0/settings.ini"
        "gtk-4.0/settings.ini"
      ] (_: {text = gtkconfig;});
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

    # qt = {
    #   enable = false;
    #   style.name = "kvantum";
    #   platformTheme.name = "kvantum";
    # };
  };
}
