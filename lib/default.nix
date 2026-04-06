{...}: let
in {
  homelabUrl = service: config: "http://${config.homelab.services.${service}.subdomain}.${config.homelab.baseUrl}";
}
