{...}: {
  perSystem = {pkgs, ...}: {
    packages.space = pkgs.callPackage ./_package.nix {};
  };
}
