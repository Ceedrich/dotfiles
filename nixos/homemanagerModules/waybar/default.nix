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
    modules-left =
      lib.optional m.window.enable "hyprland/window";
    modules-center =
      (lib.optional m.clock.enable "clock")
      ++ (lib.optional m.player.enable "group/music-player")
      ++ (lib.optional m.workspaces.enable "hyprland/workspaces")
      ++ (lib.optional m.minimized.enable "custom/minimized")
      ++ (lib.optional m.audio.enable "pulseaudio")
      ++ (lib.optional m.battery.enable "battery")
      ++ (lib.optional m.backlight.enable "backlight");
    modules-right =
      (lib.optional m.idle_inhibitor.enable "idle_inhibitor")
      ++ (lib.optional m.notification.enable "custom/notification")
      ++ (lib.optional m.powermenu.enable "group/powermenu")
      ++ (lib.optional m.tray.enable "tray");
  in
    lib.mkIf cfg.enable {
      programs.waybar = {
        systemd.enable = true;
        settings.${cfg.mainBar} = {
          inherit modules-left modules-right modules-center;
          position = "top";
        };

        style = let
          eachPlace = style: let
            css =
              ""
              + (lib.optionalString (modules-left != []) ''.modules-left ${style}'')
              + (lib.optionalString (modules-center != []) ''.modules-center ${style}'')
              + (lib.optionalString (modules-right != []) ''.modules-right ${style}'');
          in
            css;
        in ''
          ${builtins.readFile ./style.css}
          ${eachPlace ''
            {
              background-color: @base;
              color: @text;
              border-radius: 100rem;
              box-shadow: inset 0 0 0 1px @surface1;
              padding: 0.5rem 1rem;
            }
          ''}
        '';
      };
    };
}
