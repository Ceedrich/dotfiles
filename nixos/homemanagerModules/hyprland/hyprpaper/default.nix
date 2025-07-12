{
  lib,
  config,
  ...
}: {
  options = {
    hyprpaper.enable = lib.mkEnableOption "enable hyprpaper";
  };
  config = lib.mkIf config.hyprpaper.enable {
    services.hyprpaper = {
      enable = true;
      settings = {
        preload = "${./wallpaper.jpg}";
        wallpaper = ", ${./wallpaper.jpg}";
      };
    };
  };
}
