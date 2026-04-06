{...}: {
  flake.nixosModules.hyprtoolkit = {
    pkgs,
    config,
    ...
  }: {
    home-manager.sharedModules = let
      catppuccin-hyprtoolkit = pkgs.fetchFromGitHub {
        owner = "catppuccin";
        repo = "hyprtoolkit";
        rev = "main";
        hash = "sha256-D05IJCPK/9jOfqti0dlhymLBPwLf/PFtkP2nR+F1DDk=";
      };
    in [
      ({...}: {
        xdg.configFile."hypr/hyprtoolkit.confg".source = "${catppuccin-hyprtoolkit}/themes/${config.catppuccin.flavor}/catppuccin-${config.catppuccin.flavor}-${config.catppuccin.accent}";
      })
    ];
  };
}
