{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
  ];

  fileSystems."/media-server" = {
    device = "/dev/disk/by-label/drive1";
    fsType = "ext4";
  };
  services.udev.enable = true;
  boot.kernelModules = ["sg"];

  services = {
    homepage-dashboard.enable = true;
    jellyfin.enable = true;
    jellyfin.openFirewall = true;
  };

  systemd.services.hd-idle = {
    description = "External HD spin down daemon";
    wantedBy = ["multi-user.target"];
    serviceConfig = {
      ExecStart = "${pkgs.hd-idle}/bin/hd-idle -i 0 -a /dev/disk/by-label/drive1 -i 900";
    };
  };

  homelab.backup = {
    enable = true;
    repository = "sftp:ceedrich@jarjar:backups-jabba";
    paths = ["/var/lib/jellyfin"];
  };

  # users.users.arm = {
  #   isNormalUser = true;
  #   description = "arm";
  #   group = "arm";
  #   extraGroups = [ "arm" "cdrom" "video" "render" "docker" ];
  # };
  #
  # users.groups.arm = { };
  #
  # virtualisation = {
  #   docker.enable = true;
  #   oci-containers.backend = "docker";
  # };

  # virtualisation.oci-containers.containers."arm-rippers" = {
  #   autoStart = true;
  #   image = "automaticrippingmachine/automatic-ripping-machine:latest";
  #   ports = [ "${toString ports.arm}:8080" ];
  #
  #   environment = {
  #     ARM_UID = "1001";
  #     ARM_GID = "985";
  #   };
  #
  #   volumes = [
  #     "/home/arm:/home/arm"
  #     "/home/arm/music:/home/arm/music"
  #     "/home/arm/logs:/home/arm/logs"
  #     "/media-server:/home/arm/media"
  #     "/home/arm/config:/etc/arm/config"
  #   ];
  #   extraOptions = [
  #     "--device=/dev/sr0:/dev/sr0"
  #     "--privileged"
  #   ];
  # };
  #
  # systemd.tmpfiles.rules = [
  #   "d /media-server 1777 arm arm"
  #   "d /home/arm 1777 arm arm"
  #   "d /home/arm/music 1777 arm arm"
  #   "d /home/arm/logs 1777 arm arm"
  #   "d /home/arm/media 1777 arm arm"
  #   "d /home/arm/config 1777 arm arm"
  # ];

  services.openssh = {
    enable = true;
    ports = [22];
    settings = {
      PasswordAuthentication = false;
      AllowUsers = null;
    };
  };

  system.stateVersion = "24.11";
}
