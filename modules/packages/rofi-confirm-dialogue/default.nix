{...}: {
  perSystem = {pkgs, ...}: {
    packages.rofi-confirm-dialogue = pkgs.callPackage ./_package.nix {};
  };
}
