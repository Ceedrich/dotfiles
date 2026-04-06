{...}: {
  perSystem = {pkgs, ...}: {
    packages.rofi-file-picker = pkgs.callPackage ./_package.nix {};
  };
}
