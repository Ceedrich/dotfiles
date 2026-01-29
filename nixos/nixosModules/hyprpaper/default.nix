{
  config,
  lib,
  ...
}: let
  cfg = config.services.hyprpaper;
in {
  options.services.hyprpaper = {
    enable = lib.mkEnableOption "Hyprpaper";
  };

  config = lib.mkIf cfg.enable {
    global-hm.config = {
      services.hyprpaper = {
        enable = true;
        settings = {
          ipc = "on";
          splash = false;

          preload = ["${../../assets/wallpaper.jpg}"];

          wallpaper = [
            {
              path = "${../../assets/wallpaper.jpg}";
              fit_mode = "cover";
            }
          ];
        };
      };
    };
  };
}
