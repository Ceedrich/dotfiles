{moduleWithSystem, ...}: {
  flake.nixosModules.hyprtoolkit = moduleWithSystem ({inputs'}: {config, ...}: let
    catppuccin-hyprtoolkit = inputs'.catppuccin.packages.hyprtoolkit;
  in {
    environment.etc."xdg/hypr/hyprtoolkit.conf".source = "${catppuccin-hyprtoolkit}/${config.catppuccin.flavor}/catppuccin-${config.catppuccin.flavor}-${config.catppuccin.accent}.conf";
  });
}
