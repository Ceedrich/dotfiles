{ pkgs, ... }: {
  home.username = "ceedrich";
  home.homeDirectory = "/home/ceedrich";

  mangohud.enable = true;

  modrinth-unfree.enable = true;
  spotify-unfree.enable = true;
  discord-unfree.enable = true;

  allowedUnfree = [ "aseprite" ];
  home.packages = with pkgs; [
    aseprite
    ldtk
    (pkgs.callPackage ../packages/serve-dir.nix { })
  ];

  home.stateVersion = "24.11";
}
