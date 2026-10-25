{
  flake.nixosModules.cliphist = {
    pkgs,
    lib,
    config,
    ...
  }: {
    options.services.cliphist = {
      package = lib.mkPackageOption pkgs "cliphist" {};
      clipboardPackage = lib.mkPackageOption pkgs "wl-clipboard" {};
      systemdTargets = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = ["graphical-session.target"];
      };
    };

    config = let
      cfg = config.services.cliphist;
    in {
      environment.systemPackages = [cfg.package];
      systemd.user.services.cliphist = {
        description = "Clipboard management daemon";
        partOf = cfg.systemdTargets;
        after = cfg.systemdTargets;
        wantedBy = cfg.systemdTargets;

        serviceConfig = {
          Type = "simple";
          ExecStart = "${lib.getExe' cfg.clipboardPackage "wl-paste"} --watch ${lib.getExe cfg.package} store";
          Restart = "on-failure";
        };
      };
    };
  };
}
