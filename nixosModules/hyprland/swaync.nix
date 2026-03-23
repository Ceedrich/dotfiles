{
  pkgs,
  config,
  lib,
  ...
}: let
  hl = config.programs.hyprland;
  cfg = hl.modules.swaync;
in {
  options.programs.hyprland.modules.swaync = {
    enable =
      lib.mkEnableOption "Swaync hyprland module"
      // {
        default = config.services.swaync.enable;
        defaultText = lib.literalExpression "config.services.swaync.enable";
      };
    package =
      (lib.mkPackageOption pkgs "swaynotificationcenter" {})
      // {
        default = config.services.swaync.package;
        defaultText = lib.literalExpression "config.services.swaync.package";
      };
  };

  config = lib.mkIf cfg.enable {
    programs.hyprland.extra-packages = [cfg.package];
    global-hm.config.wayland.windowManager.hyprland = {
      settings.bind = [
        "${hl.mainMod}, N, exec, swaync-client -t"
      ];
    };
  };
}
