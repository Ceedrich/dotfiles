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

    discord
    spotify

    aseprite
    handbrake
    ldtk
    tiled
  ];

  allowedUnfree = [
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

  home-manager.sharedModules = [
    {
      programs.bat.package = pkgs.bat;
    }
  ];

  systemd.packages = with pkgs; [lact];
  systemd.services.lactd.wantedBy = ["multi-user.target"];

  system.stateVersion = "24.11";
}
