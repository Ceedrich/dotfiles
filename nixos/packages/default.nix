{
  perSystem = {pkgs, ...}: let
    inherit (pkgs) callPackage;
  in {
    packages = rec {
      rofi-confirm-dialogue = callPackage ./rofi-confirm-dialogue.nix {};
      find-icons = callPackage ./find-icons.nix {};
      minecraft-backup = callPackage ./minecraft-backup.nix {};
      # TODO: modrinth-prefetch
      passmenu = callPackage ./passmenu {};
      pdfopen = callPackage ./pdfopen.nix {};
      power-menu = callPackage ./power-menu.nix {inherit rofi-confirm-dialogue;};
      rofi-pdfmenu = callPackage ./rofi-pdfmenu.nix {inherit pdfopen;};
      rebuild-system = callPackage ./rebuild-system.nix {};
      serve-dir = callPackage ./serve-dir.nix {};
      space = callPackage ./space.nix {};
      test-icons = callPackage ./test-icons.nix {inherit find-icons;};
      waybar-player = callPackage ./waybar-player {};
    };
  };
}
