{
  lib,
  config,
  ...
}: let
  cfg = config.services.jellyfin;
in {
  config = lib.mkIf cfg.enable {
    homelab.reverseProxies.jellyfin.port = 8096;
  };
}
