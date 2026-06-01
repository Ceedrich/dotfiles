{inputs, ...}: {
  flake.nixosModules.cshell = {
    pkgs,
    lib,
    ...
  }: let
    package = inputs.cshell.packages.${pkgs.stdenv.hostPlatform.system}.default;
  in {
    environment.systemPackages = [package];

    systemd.user.services."cshell" = {
      enable = true;
      wantedBy = ["graphical-session.target"];
      description = "Cshell, MY graphical shell";
      after = ["graphical-session.target"];

      serviceConfig = {
        Type = "simple";
        ExecStart = lib.getExe package;
        Restart = "on-failure";
      };
    };
  };
}
