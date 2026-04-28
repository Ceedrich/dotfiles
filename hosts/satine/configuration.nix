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
    # selfnixosmodules.fingerprint-sensor
    selfnixosmodules.kanata
    selfnixosmodules.steam
    selfnixosmodules.bluetooth
    selfnixosmodules.mangowm
    selfnixosmodules.cosmic
  ];
  boot.loader.grub.useOSProber = true; # Needed for grub to detect windows

  musnix.enable = true;

  programs = {
    steam.enable = true;
  };
  services.hyprpaper.enable = true;
  services.upower.enable = true;

  home-manager.sharedModules = [
    {
      wayland.windowManager.hyprland.extraConfig = "monitor = , preferred, auto, 1";
    }
  ];

  environment.systemPackages = with pkgs; [
    snapshot
    jetbrains.idea-oss

    # unity
    unityhub
  ];

  allowedUnfree = [
    # unity
    "unityhub"
    "corefonts"
  ];

  hardware.graphics = {
    enable32Bit = true;
    enable = true;
  };

  networking.networkmanager.wifi.powersave = false;

  system.stateVersion = "24.11";
}
