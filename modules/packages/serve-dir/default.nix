{...}: {
  perSystem = {pkgs, ...}: {
    packages.serve-dir = pkgs.callPackage ./_package.nix {};
  };
}

