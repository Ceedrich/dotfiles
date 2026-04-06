{...}: {
  perSystem = {pkgs, ...}: {
    packages.modrinth-prefetch = pkgs.callPackage ./_package.nix {};
  };
}
