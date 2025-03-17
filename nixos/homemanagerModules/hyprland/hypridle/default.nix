{ lib, config, ... }:

{
  options = {
    hypridle.enable = lib.mkEnableOption "enable hypridle";
  };
  config = lib.mkIf config.hypridle.enable {
    services.hypridle = {
      enable = true;
      settings = {

        general = {
          lock_cmd = "pidof hyprlock || hyprlock"; # avoid starting multiple hyprlock instances.
          before_sleep_cmd = "loginctl lock-session"; # lock before suspend.
          after_sleep_cmd = "hyprctl dispatch dpms on"; # to avoid having to press a key twice to turn on the display.
        };

        listener = [
          {
            timeout = 60 * 5;
            on-timeout = "loginctl lock-session";
          }
          {
            timeout = 60 * 6;
            on-timeout = "hyprctl dispatch dpms off";
            on-resume = "hyprctl dispatch dpms on";
          }
          {
            timeout = 60 * 30;
            on-timeout = "systemctl suspend";
          }
        ];
      };
    };
  };
}
