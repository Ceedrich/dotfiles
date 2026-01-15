{
  lib,
  config,
  meta,
  ...
}: let
  cfg = config.services.pihole;
in {
  options.services.pihole = {
    enable = lib.mkEnableOption "Pihole";
  };
  config = lib.mkIf cfg.enable {
    services = {
      pihole-ftl = {
        enable = true;
        lists = [
          {
            url = "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts";
            type = "block";
            enabled = true;
            description = "Steven Black's HOSTS";
          }
          {
            url = "https://big.oisd.nl";
            type = "block";
            enabled = true;
            description = "oisd blocklist";
          }
        ];
        settings = {
          dns = {
            listeningMode = "ALL";
            upstreams = [
              "1.1.1.1" # Cloudflare
              "1.0.0.1" # Cloudflare 2
            ];
            # cnameRecords = [
            #   "home.ceedri.ch,jabba"
            #   "cediflix.ceedri.ch,jabba"
            #   "minecraft.ceedri.ch,jarjar"
            # ];
            hosts = let
              hosts = lib.listToAttrs (lib.concatMap (host: let
                ipv4 = host.tailscale.ipv4;
                services = lib.attrValues host.services;
              in
                lib.concatMap (service: let
                  subdomains = service.subdomains;
                in
                  lib.map (subdomain: {
                    name = "${subdomain}.${config.homelab.baseUrl}";
                    value = ipv4;
                  })
                  subdomains)
                services) (lib.attrValues config.homelab.hosts));
            in
              lib.mapAttrsToList (name: ip: "${ip} ${name}") hosts;
          };
          ntp = {
            ipv4.active = false;
            ipv6.active = false;
            sync.active = false;
          };
        };
      };
      pihole-web = {
        enable = true;
        ports = [25555];
      };
    };
    homelab.reverseProxies.pihole.port = 25555;
  };
}
