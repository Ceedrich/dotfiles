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
  config = let
    accent = "mauve";
    flavor = "mocha";
  in
    lib.mkIf cfg.enable {
      gtk = let
        dark-theme = "gtk-application-prefer-dark-theme";

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

      catppuccin.flavor = lib.mkDefault flavor;
      catppuccin.enable = lib.mkDefault true;
      catppuccin.zsh-syntax-highlighting.enable = lib.mkDefault false;

      qt = {
        enable = true;
        style.name = "kvantum";
        platformTheme.name = "kvantum";
      };
    };
}
