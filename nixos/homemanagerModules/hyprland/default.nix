{
  lib,
  config,
  ...
}: let
  cfg = config.settings.hyprland;
  inherit (lib) mkEnableOption mkDefault mkIf;
in {
  options.settings.hyprland = {
    enable = mkEnableOption "enable hyprland config";
  };
  imports = [
    # ./hyprland.nix
    ./hypridle
    ./hyprpaper
    ./hyprlock
    ./rofi
    ./waybar
  ];

  config = {
    # From https://github.com/nix-community/home-manager/blob/3b955f5f0a942f9f60cdc9cacb7844335d0f21c3/modules/services/window-managers/hyprland.nix#L330-L340
    # See also UWSM
    systemd.user.targets.hyprland-session = {
      Unit = {
        Description = "Hyprland compositor session";
        Documentation = ["man:systemd.special(7)"];
        BindsTo = ["graphical-session.target"];
        Wants = ["graphical-session-pre.target"];
        After = ["graphical-session-pre.target"];
      };
    };

    programs = mkIf cfg.enable {
      waybar.enable = mkDefault true;
      hyprlock.enable = mkDefault true;
      rofi.enable = mkDefault true;
    };
    services = {
      hyprpaper.enable = mkDefault true;
      hypridle.enable = mkDefault true;
    };
  };
}
