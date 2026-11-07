{
  flake.nixosModules.wl-clip-persist = {
    pkgs,
    lib,
    config,
    ...
  }: {
    options = {
      services.wl-clip-persist = {
        package = lib.mkPackageOption pkgs "wl-clip-persist" {};
        systemdTargets = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = ["graphical-session.target"];
        };
      };
    };
    config = let
      cfg = config.services.wl-clip-persist;
    in {
      environment.systemPackages = [cfg.package];
      systemd.user.services.wl-clip-persist = {
        description = "Wayland clipboard persistence daemon";

        partOf = cfg.systemdTargets;
        after = cfg.systemdTargets;
        wantedBy = cfg.systemdTargets;

        serviceConfig = {
          Type = "simple";
          ExecStart = "${lib.getExe cfg.package} --clipboard regular";
        };
      };
    };
  };
}
