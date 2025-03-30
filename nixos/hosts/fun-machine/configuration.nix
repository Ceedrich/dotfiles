{ pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  hyprland.enable = false;

  services.tailscale.enable = true;

  services.udev.enable = true;
  boot.kernelModules = [ "sg" ];

  users.users.arm = {
    isNormalUser = true;
    description = "arm";
    group = "arm";
    extraGroups = [ "arm" "cdrom" "video" "render" "docker" ];
  };

  users.groups.arm = { };

  virtualisation = {
    docker.enable = true;
    oci-containers.backend = "docker";
  };

  virtualisation.oci-containers.containers."arm-rippers" = {
    autoStart = true;
    image = "automaticrippingmachine/automatic-ripping-machine:latest";
    ports = [ "8080:8080" ];

    environment = {
      ARM_UID = "1001";
      ARM_GID = "985";
    };

    volumes = [
      "/home/arm:/home/arm"
      "/home/arm/music:/home/arm/music"
      "/home/arm/logs:/home/arm/logs"
      "/home/arm/media:/home/arm/media"
      "/home/arm/config:/etc/arm/config"
    ];
    extraOptions = [
      "--device=/dev/sr0:/dev/sr0"
      "--privileged"
    ];
  };

  systemd.tmpfiles.rules = [ 
    "d /home/arm 1777 arm arm" 
    "d /home/arm/music 1777 arm arm" 
    "d /home/arm/logs 1777 arm arm" 
    "d /home/arm/media 1777 arm arm" 
    "d /home/arm/config 1777 arm arm" 
  ];

  services.jellyfin = {
    enable = true;
    openFirewall = true;
  };

  services.openssh = {
    enable = true;
    ports = [ 22 ];
    settings = {
      PasswordAuthentication = false;
      AllowUsers = null;
    };
  };

  networking.firewall.allowedTCPPorts = [ 22 8080 ];

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
