{
  lib,
  config,
  ...
}: let
  cfg = config.settings.bluetooth;
in {
  options.settings.bluetooth = {
    enable = lib.mkEnableOption "enable bluetooth";
  };
  config = lib.mkIf cfg.enable {
    hardware.bluetooth = {
      enable = true;
      settings = {
        General = {
          Enable = "Source,Sink,Media,Socket";
        };
      };
    };
    services.blueman.enable = true;
  };
}
