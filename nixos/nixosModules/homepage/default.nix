{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.services.homepage-dashboard;
  hl = config.homelab;
in {
  config = lib.mkIf cfg.enable {
    homelab.reverseProxies.homepage-dashboard.port = 3000;
    services.homepage-dashboard = {
      allowedHosts = let
        urls = lib.map (s: "${s}.${hl.baseUrl}") hl.services.homepage-dashboard.subdomains;
      in "localhost,127.0.0.1,${lib.concatStringsSep "," urls}";
      listenPort = 3000;
      services = [
        {
          "Media" = [
            # {
            #   "Automatic Ripping Machine" = {
            #     description = "Automatically Digitizes DVD'S";
            #     href = "http://${meta.hostname}:${toString ports.arm}";
            #     icon = "mdi-disc-player";
            #   };
            # }
            {
              "Jellyfin" = {
                icon = "jellyfin.png";
                description = "Media Server to watch movies and TV shows";
                href = pkgs.ceedrichLib.homelabUrl "jellyfin" config;
              };
            }
          ];
          "Admin" = [
            {
              "Pihole" = {
                icon = "si-Pi-hole";
                description = "Ad blocker and DNS server";
                href = pkgs.ceedrichLib.homelabUrl "pihole" config;
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
            disk = "/media-server";
            units = "metric";
          };
        }
      ];

      #

      settings = {
        title = "Ceedrich's HomeLab";
        layout = {
          "Media" = {
            style = "row";
            header = true;
            columns = 4;
          };
          "Admin" = {
            style = "row";
            header = true;
            columns = 4;
          };
        };
      };
    };
  };
}
