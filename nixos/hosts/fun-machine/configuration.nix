{ pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  hyprland.enable = false;

  services.tailscale.enable = true;

  services.openssh = {
    enable = true;
    ports = [ 22 ];
    settings = {
      PasswordAuthentication = true;
      AllowUsers = null;
    };
  };

  networking.firewall.allowedTCPPorts = [ 22 ];

  environment.systemPackages = with pkgs; [
    vim
    ghostty
    home-manager
    wget
  ];

  # Enable CUPS to print documents.
  services.printing.enable = true;

  system.stateVersion = "24.11";

}
