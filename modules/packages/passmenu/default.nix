{...}: {
  perSystem = {pkgs, ...}: {
    packages.passmenu = pkgs.callPackage ./_package.nix {};
  };
}
