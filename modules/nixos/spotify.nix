{inputs, ...}: {
  flake.nixosModules.spotify = {
    pkgs,
    config,
    ...
  }: {
    imports = [inputs.spicetify-nix.nixosModules.default];
    allowedUnfree = ["spotify"];
    programs.spicetify = let
      spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
    in {
      enable = true;
      theme = spicePkgs.themes.catppuccin;
      colorScheme = config.catppuccin.flavor;
    };
  };
}
