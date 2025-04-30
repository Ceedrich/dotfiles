{ pkgs, ... }: {
  home.username = "ceedrich";
  home.homeDirectory = "/home/ceedrich";

  hyprland.enable = false;

  spotify-unfree.enable = true;

  rofi.enable = true;

  home.packages = [
    (import ../homemanagerModules/hyprland/rofi/power-menu.nix { inherit pkgs; })
  ];


  home.stateVersion = "24.11";
}
