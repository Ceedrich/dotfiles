{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.settings.theming;
in {
  options.settings.theming = {
    enable = lib.mkEnableOption "enable theming";
  };
  config = lib.mkIf cfg.enable {
    gtk = let
      key = "gtk-application-prefer-dark-theme";
    in {
      enable = true;
      gtk3.extraConfig = {
        ${key} = 1;
      };
      gtk4.extraConfig = {
        ${key} = 1;
      };
    };

    catppuccin.flavor = lib.mkDefault "mocha";
    catppuccin.enable = lib.mkDefault true;
    catppuccin.zsh-syntax-highlighting.enable = lib.mkDefault false;
    # catppuccin.gtk.enable = lib.mkDefault true;
    home.packages = [pkgs.catppuccin-gtk];

    catppuccin = {
      mako.enable = false;
    };

    qt = {
      enable = true;
      style.name = "kvantum";
      platformTheme.name = "kvantum";
    };
  };
}
