{
  lib,
  config,
  ...
}: let
  cfg = config.services.hyprpaper;
in {
  services.hyprpaper = lib.mkIf cfg.enable {
    settings = {
      preload = "${./wallpaper.jpg}";
      wallpaper = ", ${./wallpaper.jpg}";
    };
  };
}
