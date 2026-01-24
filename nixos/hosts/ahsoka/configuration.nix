{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
    ../jarjar/minecraft-servers
    ../_graphical
  ];

  global-hm.config.programs.mangohud.enable = true;

  programs = {
    coolercontrol.enable = true;
    modrinth.enable = true;
    steam.enable = true;
  };
  environment.systemPackages = with pkgs; [
    lact
    owncloud-client

    unityhub

    discord
    spotify

    aseprite
    handbrake
    ldtk
    tiled
  ];

  allowedUnfree = [
    # Unity
    "unityhub"
    "corefonts"

    "aseprite"
    "discord"
    "spotify"
  ];

  services.waybar.modules = {
    battery.enable = false;
    backlight.enable = false;
  };

  settings.bluetooth.enable = true;

  hardware.graphics = {
    enable32Bit = true;
    enable = true;
  };

  systemd.packages = with pkgs; [lact];
  systemd.services.lactd.wantedBy = ["multi-user.target"];

  system.stateVersion = "24.11";
}
