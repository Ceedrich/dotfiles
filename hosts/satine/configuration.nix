{
  pkgs,
  inputs,
  selfpkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../_graphical
    inputs.musnix.nixosModules.musnix
  ];

  services.fprintd.enable = true;
  services.dbus.packages = [selfpkgs.libfprint-2-tod1-synatudor];
  systemd.packages = [selfpkgs.libfprint-2-tod1-synatudor];
  systemd.units."fprintd.service".wantedBy = ["multi-user.target"];
  services.fprintd.tod = {
    enable = true;
    driver = selfpkgs.libfprint-2-tod1-synatudor;
  };

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
    selfpkgs.libfprint-2-tod1-synatudor
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
