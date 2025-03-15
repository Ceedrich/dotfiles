{ inputs, lib, ... }: {
  imports = [
    ./kanata
    ./window-manager
    inputs.catppuccin.nixosModules.catppuccin
  ];

  catppuccin.flavor = lib.mkDefault "mocha";
  catppuccin.enable = lib.mkDefault true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
