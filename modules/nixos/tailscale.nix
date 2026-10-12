{
  flake.nixosModules.tailscale = {
    lib,
    config,
    pkgs,
    ...
  }: let
    cfg = config.services.tailscale;
  in {
    options.services.tailscale = {
      tray = {
        enable = lib.mkEnableOption "Tailscale tray";
      };
    };
    config.services.tailscale.enable = true;
    config.systemd.user.services.tailscale-systray = let
      systemd-target = "graphical-session.target";
    in
      lib.mkIf cfg.tray.enable {
        enable = true;
        description = "Tailscale systray application";
        requires = ["tray.target"];
        after = [systemd-target "tray.target"];
        partOf = [systemd-target];
        wantedBy = [systemd-target];
        serviceConfig = {
          ExecStart = "${lib.getExe pkgs.tailscale-systray}";
        };
      };
  };
}
