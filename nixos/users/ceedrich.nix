{ pkgs, ... }: {
  home.username = "ceedrich";
  home.homeDirectory = "/home/ceedrich";

  mangohud.enable = true;

  modrinth-unfree.enable = true;
  spotify-unfree.enable = true;
  discord-unfree.enable = true;

  allowedUnfree = [ "aseprite" ];
  home.packages = with pkgs; [ aseprite ];

  home.stateVersion = "24.11";
}
