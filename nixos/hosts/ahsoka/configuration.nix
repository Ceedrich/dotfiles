{
  pkgs,
  pkgs-unstable,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../jarjar/minecraft-servers
  ];

  programs = {
    coolercontrol.enable = true;
    hyprland.enable = true;
    modrinth.enable = true;
    steam.enable = true;
    thunderbird.enable = true;
  };
  environment.systemPackages = with pkgs; [
    lact
    owncloud-client
    texliveFull
    zathura

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

  services.waybar = {
    enable = true;
    modules = {
      battery.enable = false;
      backlight.enable = false;
    };
    enableHyprlandSupport = true;
  };

  settings.bluetooth.enable = true;

  hardware.graphics = {
    enable32Bit = true;
    enable = true;
  };

  systemd.packages = with pkgs; [lact];
  systemd.services.lactd.wantedBy = ["multi-user.target"];

  services.mpvpaper.enable = true;
  services.openssh = {
    enable = true;
    ports = [22];
    settings = {
      PasswordAuthentication = false;
      AllowUsers = null;
    };
  };

  networking.firewall.allowedTCPPorts = [22];

  services.tailscale.enable = true;
  services.tailscale.package = pkgs-unstable.tailscale;

  system.stateVersion = "24.11";
}
