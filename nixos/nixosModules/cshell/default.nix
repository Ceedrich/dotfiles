{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.services.cshell;
in {
  options.services.cshell = {
    enable = lib.mkEnableOption "CShell";
    package = lib.mkPackageOption pkgs "cshell" {};
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [cfg.package];
    systemd.user.services.cshell = {
      enable = true;
      description = "Ceedrich Shell";
      documentation = ["https://github.com/Ceedrich/cshell"];
      wantedBy = ["graphical-session.target"];
      serviceConfig = {ExecStart = "${cfg.package}/bin/cshell";};
    };
  };
}
