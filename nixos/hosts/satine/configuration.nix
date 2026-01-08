{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
    ../_graphical
  ];

  programs.hyprland.extraConfig = "monitor = , preferred, auto, 1";

  programs = {
    thunderbird.enable = true;
    zathura.enable = true;
    modrinth.enable = true;
    steam.enable = true;
  };

  environment.systemPackages = with pkgs; [
    texliveFull
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
  networking.networkmanager.wifi.powersave = false;

  system.stateVersion = "24.11";
}
