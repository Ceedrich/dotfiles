{ lib, config, ... }: {
  imports = [
    ./hyprland.nix
    ./hypridle
    ./hyprlock
    ./wofi
    ./waybar
  ];
  config = lib.mkIf config.hyprland.enable {
    waybar = {
      enable = lib.mkDefault true;
      modules = {
        audio.enable = lib.mkDefault true;
        clock.enable = lib.mkDefault true;
        tray.enable = lib.mkDefault true;
      };
    };

    hyprlock.enable = lib.mkDefault true;
    hypridle.enable = lib.mkDefault true;
    wofi.enable = lib.mkDefault true;

  };
}
