{
  lib,
  config,
  ...
}: let
  cfg = config.services.tailscale;
  tray = cfg.tray;
in {
  options.services.tailscale = {
    tray = {
      enable = lib.mkEnableOption "Tailscale tray";
    };
  };
  config = lib.mkIf cfg.enable {
    global-hm.config.services.tailscale-systray = {
      enable = tray.enable;
      package = cfg.package;
    };
  };
}
