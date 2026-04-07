{
  lib,
  config,
  pkgs,
  ...
}: let
  hl = config.programs.hyprland;
  cfg = hl.modules.screenshots;
in {
  options.programs.hyprland.modules.screenshots = {
    enable = lib.mkEnableOption "Screenshots hyprland module" // {default = true;};
    hyprshotPackage = lib.mkPackageOption pkgs "hyprshot" {};
  };

  config = lib.mkIf cfg.enable {
    programs.hyprland.extra-packages = [cfg.hyprshotPackage];

    home-manager.sharedModules = [
      (args: {
        wayland.windowManager.hyprland = let
          # TODO: replace with home-manager config `xdg.userDirs.pictures`
          xdgPictures = args.config.xdg.userDirs.pictures;
          pictureDir =
            if xdgPictures != null
            then xdgPictures
            else "$HOME/Pictures/";
          screenshotCommand = "${lib.getExe cfg.hyprshotPackage} -o ${pictureDir}/Screenshots";
        in {
          settings.bind = [
            ", PRINT, exec, ${screenshotCommand} -m region"
            "${hl.mainMod}, S, exec, ${screenshotCommand} -m region"

            "SHIFT, PRINT, exec, ${screenshotCommand} -m window"
            "${hl.mainMod} SHIFT, S, exec, ${screenshotCommand} -m window"
          ];
        };
      })
    ];
  };
}
