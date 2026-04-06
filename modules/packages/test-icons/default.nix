{...}: {
  perSystem = {
    pkgs,
    self',
    ...
  }: {
    packages.test-icons = pkgs.callPackage ./_package.nix {inherit (self'.packages) find-icons;};
  };
}
