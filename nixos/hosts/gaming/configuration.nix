{ pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  steam-unfree.enable = true;
  services.xserver.videoDrivers = [ "amdgpu" ];

  environment.systemPackages = with pkgs; [
    vim
  ];

  services.openssh = {
    enable = true;
    ports = [ 22 ];
    settings = {
      PasswordAuthentication = false;
      AllowUsers = null;
    };
  };

  networking.firewall.allowedTCPPorts = [ 22 ];

  services.tailscale.enable = true;

  system.stateVersion = "24.11";

}
