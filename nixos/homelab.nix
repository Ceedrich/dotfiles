{
  lib,
  config,
  ...
}: let
  cfg = config.homelab;
in {
  options.homelab = with lib.types; let
    inherit (lib) mkOption;
    host = submodule ({config, ...}: {
      options = {
        hostname = mkOption {
          description = "the hostname of the machine";
          type = str;
        };
        description = mkOption {
          type = str;
          description = "description of the machine";
          default = config.hostname;
        };
        tailscale = {
          ipv4 = mkOption {
            type = str;
            description = "the tailscale assigned ipv4 address";
          };
          ipv6 = mkOption {
            type = str;
            description = "the tailscale assigned ipv6 address";
          };
        };
      };
    });
    reverseProxyConfig = submodule {
      options = {
        subdomain = mkOption {
          type = str;
          description = "The subdomain under which it is reachable, i.e. `subdomain.\${homelab.baseUrl}`";
        };
        url = mkOption {
          type = str;
          description = "The url the reverse proxy points to";
          default = "http://127.0.0.1";
        };
        port = mkOption {
          type = int;
          description = "The port the reverse proxy points to";
          default = 80;
        };
      };
    };
  in {
    baseUrl = mkOption {
      description = "Base url used for all services";
      default = "ceedri.ch"; # TODO: find better url.
    };
    hosts = mkOption {
      type = attrsOf host;
      description = "All the hosts present in the homelab";
      default = {};
    };
    reverseProxies = mkOption {
      type = attrsOf reverseProxyConfig;
      description = "All the configurations of reverse proxies of the server";
      default = {};
    };
  };
  config = lib.mkIf (cfg.reverseProxies != {}) {
    services.nginx = {
      enable = true;
      virtualHosts = lib.genAttrs' (lib.attrValues cfg.reverseProxies) (proxyCfg: {
        name =
          if (proxyCfg.subdomain == null)
          then cfg.baseUrl
          else "${proxyCfg.subdomain}.${cfg.baseUrl}";
        value = {locations."/".proxyPass = "${proxyCfg.url}:${toString proxyCfg.port}/";};
      });
    };
  };
}
