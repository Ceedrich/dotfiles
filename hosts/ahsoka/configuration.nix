{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
    # ../jarjar/minecraft-servers
    ../_graphical
  ];

  home-manager.sharedModules = [
    {
      programs.mangohud.enable = true;
      programs.waybar.modules = {
        battery.enable = false;
        backlight.enable = false;
      };
    }
  ];

  programs = {
    coolercontrol.enable = true;
    steam.enable = true;
  };
  environment.systemPackages = with pkgs; [
    lact
    clinfo

    unityhub
    jetbrains.rider

    discord

    aseprite
    handbrake
    ldtk
    tiled
  ];

  allowedUnfree = [
    # Unity
    "unityhub"
    "corefonts"
    "rider"

    "aseprite"
    "discord"
  ];

  settings.bluetooth.enable = true;

  hardware.graphics = {
    enable32Bit = true;
    enable = true;
    extraPackages = with pkgs; [
      rocmPackages.clr.icd
    ];
  };

  systemd.packages = with pkgs; [lact];
  systemd.services.lactd.wantedBy = ["multi-user.target"];

  system.stateVersion = "24.11";
}
