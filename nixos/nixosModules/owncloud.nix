{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.services.owncloud;
in {
  options.services.owncloud = {
    enable = lib.mkEnableOption "enable OwnCloud";
  };
  config = lib.mkIf cfg.enable {
    systemd.user.services.owncloud = {
      enable = cfg.enable;
      wantedBy = ["default.target"];
      after = ["network.target"];
      wants = ["network.target"];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.owncloud-client}/bin/owncloud";
        Restart = "on-failure";
      };
    };
  };
}
