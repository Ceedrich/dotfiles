{pkgs}: let
  inherit (pkgs) callPackage;
in rec {
  find-icons = callPackage ./find-icons.nix {};
  minecraft-backup = callPackage ./minecraft-backup.nix {};
  # TODO: modrinth-prefetch
  passmenu = callPackage ./passmenu {};
  rebuild-system = callPackage ./rebuild-system.nix {};
  serve-dir = callPackage ./serve-dir.nix {};
  space = callPackage ./space.nix {};
  test-icons = callPackage ./test-icons.nix {inherit find-icons;};
}
