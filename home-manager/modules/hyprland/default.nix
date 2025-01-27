{ lib, pkgs, ... }: {
  home.packages = with pkgs; [
    hyprshot
    swaynotificationcenter
  ];
  wayland.windowManager.hyprland = {
    enable = true;
    extraConfig = lib.readFile ./hyprland.conf;
  };
  programs.waybar = {
    enable = true;
    style = lib.readFile ./waybar/style.css;
  };
  # TODO: This should be in programs.waybar.settings but it does not work yet
  home.file.".config/waybar/config.jsonc".source = ./waybar/config.json;

  programs.hyprlock = {
    enable = true;
    extraConfig = lib.readFile ./hyprlock.conf;
  };

  programs.wofi = {
    enable = true;
    style = lib.readFile ./wofi.css;
  };
}
