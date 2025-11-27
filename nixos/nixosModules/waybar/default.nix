{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.services.waybar;
  jsonFormat = pkgs.formats.json {};
in {
  imports = [./modules];
  options.services.waybar = {
    enable = lib.mkEnableOption "enable waybar";
    package = lib.mkPackageOption pkgs "waybar" {};
    enableHyprlandSupport = lib.mkEnableOption "enable hyprland support";
    enableSwaySupport = lib.mkEnableOption "enable sway support";

    mainBar = lib.mkOption {
      default = "mainBar";
      description = "The name used to configure the main bar";
      type = lib.types.str;
    };
    settings = lib.mkOption {
      description = "A waybar config";
      default = {};
      type = lib.types.submodule {
        freeformType = jsonFormat.type;
      };
    };
    style = lib.mkOption {
      default = "";
      description = "The waybar style";
      type = lib.types.lines;
    };
  };
  config = let
    settings = lib.attrsets.attrValues cfg.settings;
    configuration = jsonFormat.generate "waybar-config.json" settings;
    m = cfg.modules;
  in
    lib.mkIf cfg.enable {
      environment.etc."xdg/waybar/config" = {
        source = configuration;
      };
      environment.etc."xdg/waybar/style.css" = {
        text = cfg.style;
      };

      services.waybar.settings.mainBar = {
        position = "top";
        modules-left =
          lib.optional m.clock.enable "clock"
          # Window
          ++ lib.optional (m.window.enable && cfg.enableSwaySupport) "sway/window"
          ++ lib.optional (m.window.enable && cfg.enableHyprlandSupport) "hyprland/window";
        modules-center = lib.optional m.player.enable "group/music-player";
        modules-right =
          # Workspaces
          (lib.optional (m.workspaces.enable && cfg.enableSwaySupport) "sway/workspaces")
          ++ (lib.optional (m.workspaces.enable && cfg.enableHyprlandSupport) "hyprland/workspaces")
          # Other modules
          ++ (lib.optional m.audio.enable "pulseaudio")
          ++ (lib.optional m.battery.enable "battery")
          ++ (lib.optional m.backlight.enable "backlight")
          ++ (lib.optional m.idle_inhibitor.enable "idle_inhibitor")
          ++ (lib.optional m.powermenu.enable "group/powermenu")
          ++ (lib.optional m.tray.enable "tray");
      };

      systemd.user.services.waybar = {
        enable = true;
        wantedBy = ["graphcal-session.target"];
        serviceConfig = {
          Type = "simple";
          ExecReload = "${pkgs.coreutils}/bin/kill -SIGUSR2 $MAINPID";
          ExecStart = "${cfg.package}/bin/waybar";
          Restart = "on-failure";
        };
      };
    };
}
