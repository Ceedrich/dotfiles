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
    services.gnome.gnome-keyring.enable = true;
    systemd.user.services.owncloud = {
      enable = cfg.enable;
      wantedBy = ["graphical-session.target"];
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
