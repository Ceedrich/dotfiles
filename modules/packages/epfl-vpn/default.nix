{
  perSystem = {pkgs, ...}: {
    packages.epfl-vpn = pkgs.callPackage ./_package.nix {};
  };
}
