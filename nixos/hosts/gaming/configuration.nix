{ pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  steam-unfree.enable = true;
  services.xserver.videoDrivers = [ "amdgpu-pro" ];

  allowedUnfree = [ "amf" "amdenc" ];

  hardware.graphics = {
    enable32Bit = true;
    extraPackages32 = with pkgs.driversi686Linux; [
      amdvlk
    ];
    extraPackages = with pkgs; [
      mesa
      amf
      amdvlk
      libva
      libva-utils
      rocmPackages.clr.icd
      clinfo
    ];
  };

  environment.systemPackages = with pkgs; [
    vim
    lact
  ];

  systemd.packages = with pkgs; [ lact ];
  systemd.services.lactd.wantedBy = [ "multi-user.target" ];

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
