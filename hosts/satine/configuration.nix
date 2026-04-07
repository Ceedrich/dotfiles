{
  pkgs,
  inputs,
  selfnixosmodules,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../_graphical
    inputs.musnix.nixosModules.musnix
    selfnixosmodules.fingerprint-sensor
    selfnixosmodules.kanata
    selfnixosmodules.steam
    selfnixosmodules.bluetooth
  ];
  boot.loader.grub.useOSProber = true; # Needed for grub to detect windows

  musnix.enable = true;

  programs = {
    steam.enable = true;
  };
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

  hardware.graphics = {
    enable32Bit = true;
    enable = true;
  };

  networking.networkmanager.wifi.powersave = false;

  system.stateVersion = "24.11";
}
