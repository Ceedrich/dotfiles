{
  inputs,
  moduleWithSystem,
  ...
}: {
  flake.nixosModules.cshell = moduleWithSystem ({self'}: {
    lib,
    config,
    ...
  }: {
    options.services.cshell = {
      systemdTargets = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = ["graphical-session.target"];
      };
    };
    config = let
      cfg = config.services.cshell;
      package = self'.packages.cshell;
    in {
      environment.systemPackages = [package];
      systemd.user.services."cshell" = {
        description = "CShell, My graphical shell";
        after = cfg.systemdTargets;
        partOf = cfg.systemdTargets;
        wantedBy = cfg.systemdTargets;
        serviceConfig = {
          Type = "simple";
          ExecStart = lib.getExe package;
          Restart = "on-failure";
        };
      };
    };
  });

  perSystem = {pkgs, ...}: {
    packages.cshell = inputs.wrappers.lib.wrapPackage {
      inherit pkgs;
      package = pkgs.quickshell;
      binName = "cshell";
      filesToExclude = ["bin/qs" "bin/quickshell"];
      flags = {
        "-p" = "${inputs.cshell}";
      };
    };
  };
}
