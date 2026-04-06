{
  perSystem = {pkgs, ...}: let
    inherit (pkgs) callPackage;
  in {
    packages = {
      # TODO: modrinth-prefetch
      waybar-player = callPackage ./waybar-player {};
    };
  };
}
