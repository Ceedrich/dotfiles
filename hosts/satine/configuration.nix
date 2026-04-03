{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../_graphical
    inputs.musnix.nixosModules.musnix
  ];

  boot.loader.grub.useOSProber = true; # Needed for grub to detect windows

  musnix.enable = true;

  programs = {
    steam.enable = true;
  };
  services.mpvpaper.enable = false;
  services.hyprpaper.enable = true;

  home-manager.sharedModules = [
    {
      wayland.windowManager.hyprland.extraConfig = "monitor = , preferred, auto, 1";
    }
  ];

  environment.systemPackages = with pkgs; [
    discord
    snapshot
    jetbrains.idea-oss

    # unity
    unityhub
    jetbrains.rider
  ];

  allowedUnfree = [
    "discord"
    # unity
    "unityhub"
    "corefonts"
    "rider"
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
