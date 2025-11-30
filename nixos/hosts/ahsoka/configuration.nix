{
  pkgs,
  pkgs-unstable,
  ...
}: {
  imports = [./hardware-configuration.nix];

  programs.steam.enable = true;
  programs.hyprland.enable = true;

  services.owncloud.enable = true;
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

  environment.systemPackages = with pkgs; [
    vim
    lact
  ];

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

  programs.coolercontrol.enable = true;

  networking.firewall.allowedTCPPorts = [22];

  services.tailscale.enable = true;
  services.tailscale.package = pkgs-unstable.tailscale;

  system.stateVersion = "24.11";
}
