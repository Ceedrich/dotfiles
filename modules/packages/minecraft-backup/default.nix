{...}: {
  perSystem = {pkgs, ...}: {
    packages.minecraft-backup = pkgs.callPackage ./_package.nix {};
  };
}
