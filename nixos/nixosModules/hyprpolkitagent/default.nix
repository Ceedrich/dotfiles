{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.services.hyprpolkitagent;
in {
  options.services.hyprpolkitagent = {
    package = lib.mkPackageOption pkgs "hyprpolkitagent" {};
    enable =
      lib.mkEnableOption "Hyprpolkitagent"
      // {
        default = config.programs.hyprland.enable;
        defaultText = lib.literalExpression ''config.services.hyprland.enable'';
      };
  };
  config = lib.mkIf cfg.enable {
    systemd.user.services."hyprpolkitagent" = {
      description = "Hyprland PolicyKit Agent";
      wantedBy = ["graphical-session.target"];
      wants = ["graphical-session.target"];
      after = ["graphical-session.target"];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${cfg.package}/libexec/hyprpolkitagent";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };
}
