{ pkgs, lib, config, ... }:

{
  options = {
    theming.enable = lib.mkEnableOption "enable theming";
  };
  config = lib.mkIf config.theming.enable {
    gtk = let key = "gtk-application-prefer-dark-theme"; in {
      enable = true;
      gtk3.extraConfig = {
        ${key} = 1;
      };
      gtk4.extraConfig = {
        ${key} = 1;
      };
      iconTheme = {
        name = "Parirus-Dark";
        package = pkgs.papirus-icon-theme;
        # name = "Qogir";
        # package = pkgs.qogir-icon-theme;
      };
    };
    catppuccin.gtk.enable = true;

    qt = {
      enable = true;
      style.name = "kvantum";
      platformTheme.name = "kvantum";
    };

  };
}
