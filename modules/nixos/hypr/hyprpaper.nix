{...}: {
  flake.nixosModules.hyprpaper = {
    config,
    lib,
    ...
  }: let
    cfg = config.services.hyprpaper;
  in {
    options.services.hyprpaper = {
      enable = lib.mkEnableOption "Hyprpaper";
    };

    config.home-manager.sharedModules = lib.mkIf cfg.enable [
      {
        services.hyprpaper = {
          enable = true;
          settings = {
            ipc = "on";
            splash = false;

            preload = ["${../../../assets/wallpaper.png}"];

            wallpaper = [
              ",${../../../assets/wallpaper.png}"
            ];
          };
        };
      }
    ];
  };
}
