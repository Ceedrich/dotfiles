{ pkgs, meta, ... }:
let
  ports = {
    arm = 8080;
    jellyfin = 8096;
    homepage = 3000;
  };
in
{
  imports = [ ./hardware-configuration.nix ];

  services.nginx = {
    enable = true;
    virtualHosts."${meta.hostname}" = {
      locations = {
        "/".proxyPass = "http://localhost:${toString ports.homepage}/";
        "/jellyfin".proxyPass = "http://localhost:${toString ports.jellyfin}/";
        "/arm".proxyPass = "http://localhost:${toString ports.arm}/";
      };
    };
  };

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

  services.kanata.enable = true;

  services.homepage-dashboard = {
    enable = true;
    allowedHosts = "localhost,127.0.0.1,${meta.hostname}";
    listenPort = ports.homepage;
    services = [
      {
        "Media" = [
          {
            "Automatic Ripping Machine" = {
              description = "Automatically Digitizes DVD'S";
              href = "/arm";
              icon = "mdi-disc-player";
            };
          }
          {
            "Jellyfin" = {
              icon = "jellyfin.png";
              description = "Media Server to watch movies and TV shows";
              href = "/jellyfin";
            };
          }
        ];
      }
    ];

    widgets = [
      {
        resources = {
          cpu = true;
          cputemp = true;
          memory = true;
          disk = "/";
          units = "metric";
        };
      }
    ];

    #

    settings = {
      title = "Ceedrich's HomeLab";
      layout = {
        "Media" = { style = "row"; header = true; columns = 4; };
      };
    };

    # services = {
    #   "Media" = [
    #     {
    #       "Automatic Ripping Machine" = {
    #         description = "Automatically Digitizes DVDS";
    #         href = "http://fun-machine:8080";
    #       };
    #       "Jellyfin" = {
    #       };
    #     }
    #   ];
    # };

  };

  virtualisation.oci-containers.containers."arm-rippers" = {
    autoStart = true;
    image = "automaticrippingmachine/automatic-ripping-machine:latest";
    ports = [ "${toString ports.arm}:8080" ];

    environment = {
      ARM_UID = "1001";
      ARM_GID = "985";
    };

    volumes = [
      "/home/arm:/home/arm"
      "/home/arm/music:/home/arm/music"
      "/home/arm/logs:/home/arm/logs"
      "/media-server:/home/arm/media"
      "/home/arm/config:/etc/arm/config"
    ];
    extraOptions = [
      "--device=/dev/sr0:/dev/sr0"
      "--privileged"
    ];
  };

  systemd.tmpfiles.rules = [
    "d /media-server 1777 arm arm"
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

  networking.firewall.allowedTCPPorts = [ 22 80 ];

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
