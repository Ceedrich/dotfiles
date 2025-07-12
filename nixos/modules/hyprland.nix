{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.applications.hyprland;
in {
  options.applications.hyprland = {
    enable = lib.mkEnableOption "enable hyprland";
  };
  config = lib.mkIf cfg.enable {
    services.xserver.enable = true;
    services.xserver.displayManager.gdm.enable = true;

    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
    };
    environment.sessionVariables = {
      WLR_NO_HARDWARE_CURSORS = "1";
      NIXOS_OZONE_WL = "1";
    };

    xdg.portal.enable = true;
    xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-gtk];

    hardware = {
      graphics.enable = true;
    };
  };
}
