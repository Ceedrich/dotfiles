{callPackage}: let
in {
  makeModFetcher = args: callPackage ../packages/modrinth-prefetch.nix args;
  homelabUrl = service: config: "http://${config.homelab.services.${service}.subdomain}.${config.homelab.baseUrl}";
}
