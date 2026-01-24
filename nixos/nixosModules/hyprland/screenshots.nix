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
    enable = lib.mkEnableOption "Screenshots hyprland module";
    hyprshotPackage = lib.mkPackageOption pkgs "hyprshot" {};
  };

  config = lib.mkIf cfg.enable {
    programs.hyprland.extra-packages = [cfg.package];
    global-hm.config.wayland.windowManager.hyprland = let
      # TODO: replace with home-manager config `xdg.userDirs.pictures`
      screenshotCommand = "${lib.getExe cfg.package} -o ~/Pictures/Screenshots";
    in {
      settings.bind = [
        ", PRINT, exec, ${screenshotCommand} -m region"
        "${cfg.mainMod}, S, exec, ${screenshotCommand} -m region"

        "SHIFT, PRINT, exec, ${screenshotCommand} -m window"
        "${cfg.mainMod} SHIFT, S, exec, ${screenshotCommand} -m window"
      ];
    };
  };
}
