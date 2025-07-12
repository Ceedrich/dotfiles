{pkgs, ...}: {
  imports = [./hardware-configuration.nix];

  applications.steam.enable = true;
  applications.hyprland.enable = true;

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

  system.stateVersion = "24.11";
}
