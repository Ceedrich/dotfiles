{
  perSystem = {pkgs, ...}: let
    inherit (pkgs) callPackage;
  in {
    packages = rec {
      rofi-confirm-dialogue = callPackage ./rofi-confirm-dialogue.nix {};
      minecraft-backup = callPackage ./minecraft-backup.nix {};
      # TODO: modrinth-prefetch
      passmenu = callPackage ./passmenu {};
      power-menu = callPackage ./power-menu.nix {inherit rofi-confirm-dialogue;};
      rebuild-system = callPackage ./rebuild-system.nix {};
      serve-dir = callPackage ./serve-dir.nix {};
      waybar-player = callPackage ./waybar-player {};
    };
  };
}
