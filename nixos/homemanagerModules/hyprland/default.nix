{ lib, config, ... }: {
  imports = [
    ./hyprland.nix
    ./hypridle
    ./hyprpaper
    ./hyprlock
    ./wofi
    ./rofi
    ./waybar
  ];
  config = lib.mkIf config.hyprland.enable {
    waybar.enable = lib.mkDefault true;

    hyprlock.enable = lib.mkDefault true;
    hyprpaper.enable = lib.mkDefault true;
    hypridle.enable = lib.mkDefault true;
    wofi.enable = lib.mkDefault false;
    rofi.enable = lib.mkDefault true;

  };
}
