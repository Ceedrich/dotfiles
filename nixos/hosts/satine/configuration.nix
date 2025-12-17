{
  pkgs,
  pkgs-unstable,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  programs = {
    hyprland = {
      enable = true;
      extraConfig = "monitor = , preferred, auto, 1";
    };
    thunderbird.enable = true;
  };

  environment.systemPackages = with pkgs; [
    texliveFull
    zathura
    owncloud-client

    discord
    spotify
  ];

  allowedUnfree = [
    "discord"
    "spotify"
  ];

  services.waybar = {
    enable = true;
    enableHyprlandSupport = true;
  };

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

  services.tailscale.enable = true;
  services.tailscale.package = pkgs-unstable.tailscale;

  system.stateVersion = "24.11";

  global-hm.config = {
    programs.zathura.enable = true;
    xdg.mimeApps.defaultApplications = {
      "application/pdf" = ["org.pwmt.zathura-pdf-mupdf.desktop"];
    };
  };
}
