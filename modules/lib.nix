{lib, ...}: {
  options = {
    flake.lib = lib.mkOption {
      type = lib.types.attrsOf lib.types.anything;
    };
  };
  config.flake.lib = {
    homelabUrl = service: config: "http://${config.homelab.services.${service}.subdomain}.${config.homelab.baseUrl}";
  };
}
