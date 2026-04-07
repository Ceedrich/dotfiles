{...}: {
  perSystem = {pkgs, ...}: {
    packages.find-icons = pkgs.callPackage ./_package.nix {};
  };
}
