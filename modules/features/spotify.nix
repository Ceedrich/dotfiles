{
  inputs,
  moduleWithSystem,
  ...
}: {
  flake.nixosModules.spotify = moduleWithSystem ({system, ...}: {config, ...}: {
    imports = [inputs.spicetify-nix.nixosModules.default];
    allowedUnfree = ["spotify"];
    programs.spicetify = let
      spicePkgs = inputs.spicetify-nix.legacyPackages.${system};
    in {
      enable = true;
      theme = spicePkgs.themes.catppuccin;
      colorScheme = config.catppuccin.flavor;
    };
  });
}
