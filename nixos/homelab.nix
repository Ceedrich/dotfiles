{
  pkgs,
  meta,
  lib,
  config,
  ...
}: let
  cfg = config.homelab;
in {
  options.homelab = with lib.types; let
    inherit (lib) mkOption;
    serviceConfig = submodule {
      options = {
        subdomains = mkOption {
          type = listOf str;
          description = "subdomains used for accessing the server";
          default = [];
        };
      };
    };
    hostConfig = let
      jsonFormat = pkgs.formats.json {};
    in
      submodule ({config, ...}: {
        freeformType = jsonFormat.type;
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
          services = mkOption {
            type = attrsOf serviceConfig;
            description = "global service configuration";
            default = {};
          };
        };
      });
    reverseProxyConfig = submodule {
      options = {
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
      type = attrsOf hostConfig;
      description = "All the hosts present in the homelab";
      default = import ./machines.nix;
    };
    reverseProxies = mkOption {
      type = attrsOf reverseProxyConfig;
      description = "All the configurations of reverse proxies of the server";
      default = {};
    };
  };
  config = let
    services = lib.attrByPath [meta.hostname "services"] {} cfg.hosts;
  in
    lib.mkIf (cfg.reverseProxies != {}) {
      assertions = builtins.map (prox: {
        assertion = lib.hasAttr prox services;
        message = "Proxy ${prox} has no configuration in `machines.nix`"; # TODO: improve this message
      }) (lib.attrNames cfg.reverseProxies);

      # TODO: add proper error handling
      services.nginx = {
        enable = true;
        virtualHosts = lib.genAttrs' (lib.concatMap ({
          name,
          value,
        }: let
          serviceName = name;
          proxyCfg = value;
          subdomains = services.${serviceName}.subdomains;
        in (builtins.map (subdomain: {
            name = "${subdomain}.${cfg.baseUrl}";
            value = {locations."/".proxyPass = "${proxyCfg.url}:${toString proxyCfg.port}/";};
          })
          subdomains))
        (lib.attrsToList cfg.reverseProxies)) (lib.id);
      };
    };
}
