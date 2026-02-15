{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.services.hyprpolkitagent;
in {
  options.services.hyprpolkitagent = {
    package = lib.mkPackageOption pkgs "hyprpolkitagent" {};
    enable =
      lib.mkEnableOption "Hyprpolkitagent"
      // {
        default = config.programs.hyprland.enable;
        defaultText = lib.literalExpression ''config.services.hyprland.enable'';
      };
  };
  config = lib.mkIf cfg.enable {
    global-hm.config.services.hyprpolkitagent = {
      inherit (cfg) package enable;
    };
  };
}
