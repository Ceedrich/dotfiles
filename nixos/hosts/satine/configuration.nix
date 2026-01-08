{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
    ../_graphical
  ];

  programs = {
    modrinth.enable = true;
    steam.enable = true;

    hyprland.extraConfig = "monitor = , preferred, auto, 1";
  };

  environment.systemPackages = with pkgs; [
    owncloud-client

    discord
    spotify
  ];

  allowedUnfree = [
    "discord"
    "spotify"
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
