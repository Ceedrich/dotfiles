{...}: {
  perSystem = {
    pkgs,
    self',
    ...
  }: {
    packages.power-menu = pkgs.callPackage ./_package.nix {inherit (self'.packages) rofi-confirm-dialogue;};
  };
}
