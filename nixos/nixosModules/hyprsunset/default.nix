{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.services.hyprsunset;
in {
  options.services.hyprsunset = {
    enable = lib.mkEnableOption "Hyprsunset";
    package = lib.mkPackageOption pkgs "hyprsunset";
  };
  config = lib.mkIf cfg.enable {
    global-hm.config.services.hyprsunset = {
      enable = true;
      settings = {
        profile = [
          {
            time = "7:30";
            identity = true;
          }
          {
            time = "21:00";
            temperature = 5000;
            gamma = 0.8;
          }
        ];
      };
    };
  };
}
