{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
    ../_graphical
  ];

  programs = {
    modrinth.enable = true;
    steam.enable = true;
  };
  services.mpvpaper.enable = false;
  services.hyprpaper.enable = true;

  global-hm.config.wayland.windowManager.hyprland.extraConfig = "monitor = , preferred, auto, 1";

  environment.systemPackages = with pkgs; [
    discord
  ];

  allowedUnfree = [
    "discord"
  ];

  settings.kanata.enable = true;
  settings.bluetooth.enable = true;

  hardware.graphics = {
    enable32Bit = true;
    enable = true;
  };

  networking.networkmanager.wifi.powersave = false;

  system.stateVersion = "24.11";
}
