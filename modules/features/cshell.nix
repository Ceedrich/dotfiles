{
  inputs,
  self,
  moduleWithSystem,
  ...
}: {
  flake.nixosModules.cshell = {
    home-manager.sharedModules = [self.homeModules.cshell];
  };
  flake.homeModules.cshell = moduleWithSystem ({self', ...}: {
    lib,
    config,
    ...
  }: let
    package = self'.packages.cshell;
  in {
    home.packages = [package];

    systemd.user.services."cshell" = {
      Unit = {
        Description = "Cshell, MY graphical shell";
        After = [config.wayland.systemd.target];
        PartOf = [config.wayland.systemd.target];
      };
      Service = {
        Type = "simple";
        ExecStart = lib.getExe package;
        Restart = "on-failure";
      };
      Install.WantedBy = [config.wayland.systemd.target];
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
