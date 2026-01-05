{
  lib,
  config,
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
              "1.1.1.1"
              "1.0.0.1"
            ];
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
  };
}
