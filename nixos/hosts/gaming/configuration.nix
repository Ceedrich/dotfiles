{ pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  steam-unfree.enable = true;
  services.xserver.videoDrivers = [ "amdgpu" ];

  environment.systemPackages = with pkgs; [
    vim
  ];

  hardware.graphics = {
    enable32Bit = true;
    extraPackages = with pkgs; [ libva libva-utils vaapiVdpau amdvlk ];
  };

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
