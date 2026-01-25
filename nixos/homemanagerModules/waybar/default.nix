{
  lib,
  config,
  ...
}: let
  cfg = config.programs.waybar;
in {
  imports = [
    ./modules
  ];
  options.programs.waybar = {
    mainBar = lib.mkOption {
      default = "mainBar";
      description = "The name used to configure the main bar";
      type = lib.types.str;
    };
  };
  config = let
    m = cfg.modules;
  in
    lib.mkIf cfg.enable {
      programs.waybar = {
        systemd.enable = true;
        style = builtins.readFile ./style.css;
        settings.${cfg.mainBar} = {
          position = "top";
          modules-left =
            lib.optional m.clock.enable "clock"
            # Window
            ++ lib.optional m.window.enable "hyprland/window";
          modules-center = lib.optional m.player.enable "group/music-player";
          modules-right =
            # Workspaces
            (lib.optional m.workspaces.enable "hyprland/workspaces")
            ++ (lib.optional m.minimized.enable "custom/minimized")
            # Other modules
            ++ (lib.optional m.audio.enable "pulseaudio")
            ++ (lib.optional m.battery.enable "battery")
            ++ (lib.optional m.backlight.enable "backlight")
            ++ (lib.optional m.idle_inhibitor.enable "idle_inhibitor")
            ++ (lib.optional m.notification.enable "custom/notification")
            ++ (lib.optional m.powermenu.enable "group/powermenu")
            ++ (lib.optional m.tray.enable "tray");
        };
      };
    };
}
