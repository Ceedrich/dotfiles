{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.services.mpvpaper;
in {
  options.services.mpvpaper = {
    enable = lib.mkEnableOption "enable mpvpaper";
    package = lib.mkPackageOption pkgs "mpvpaper" {};
  };
  config = lib.mkIf cfg.enable {
    systemd.user.services.mpvpaper = {
      enable = cfg.enable;
      wantedBy = ["graphical-session.target"];
      after = ["graphical-session.target"];
      serviceConfig = {
        Type = "simple";
        ExecStart = ''${lib.getExe cfg.package} -so "no-audio loop" "*" ${./wallpaper.mp4}'';
        Restart = "on-failure";
      };
    };
  };
}
