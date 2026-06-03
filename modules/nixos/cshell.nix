{
  inputs,
  self,
  ...
}: {
  flake.nixosModules.cshell = {
    home-manager.sharedModules = [self.homeModules.cshell];
  };
  flake.homeModules.cshell = {
    pkgs,
    lib,
    config,
    ...
  }: let
    package = inputs.cshell.packages.${pkgs.stdenv.hostPlatform.system}.default;
  in {
    home.packages = [package];

    systemd.user.services."cshell" = {
      Unit = {
        Description = "Cshell, MY graphical shell";
        After = [
          config.wayland.systemd.target
        ];
        PartOf = [
          config.wayland.systemd.target
          "tray.target"
        ];
      };
      Service = {
        Type = "simple";
        ExecStart = lib.getExe package;
        Restart = "on-failure";
      };
      Install.WantedBy = [
        config.wayland.systemd.target
        "tray.target"
      ];
    };
  };
}
