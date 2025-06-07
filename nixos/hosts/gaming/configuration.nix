{ pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  steam-unfree.enable = true;

  hardware.graphics = {
    enable32Bit = true;
    enable = true;
  };

  environment.systemPackages = with pkgs; [
    vim
    lact
  ];

  minecraft.enable = true;

  services.openssh = {
    enable = true;
    ports = [ 22 ];
    settings = {
      PasswordAuthentication = false;
      AllowUsers = null;
    };
  };

  programs.coolercontrol.enable = true;

  networking.firewall.allowedTCPPorts = [ 22 ];

  services.tailscale.enable = true;

  system.stateVersion = "24.11";

}
