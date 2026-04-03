{...}: {
  perSystem = {pkgs, ...}: {
    packages.libfprint-tod-06cb-00be = pkgs.callPackage ./_package.nix {};
  };
}
