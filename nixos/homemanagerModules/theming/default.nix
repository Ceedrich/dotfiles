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

      theme = {
        name = "catppuccin-mocha-mauve-standard";
        package = pkgs.catppuccin-gtk.override {
          variant = "mocha";
          accents = ["mauve"];
        };
      };
    in {
      enable = true;
      inherit theme;
      gtk3 = {
        inherit theme;
        extraConfig = {
          ${key} = 1;
        };
      };
      gtk4 = {
        inherit theme;
        extraConfig = {
          ${key} = 1;
        };
      };
    };

    catppuccin.flavor = lib.mkDefault "mocha";
    catppuccin.enable = lib.mkDefault true;
    catppuccin.zsh-syntax-highlighting.enable = lib.mkDefault false;
    # catppuccin.gtk.enable = lib.mkDefault true;
    home.packages = [pkgs.catppuccin-gtk];

    qt = {
      enable = true;
      style.name = "kvantum";
      platformTheme.name = "kvantum";
    };
  };
}
