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
    mkModules = mods: lib.foldl' (mods: name: mods ++ lib.optional m.${name}.enable m.${name}.name) [] mods;
    modules-left = mkModules [
      "window"
      "player" # TODO: look at vanishing modules
    ];
    modules-center = mkModules [
      "clock"
      "workspaces"
      "minimized"
      "audio"
      "battery"
      "backlight"
    ];
    modules-right = mkModules [
      "idle_inhibitor"
      "notification"
      "powermenu"
      "tray"
    ];
  in
    lib.mkIf cfg.enable {
      programs.waybar = {
        systemd.enable = true;
        settings.${cfg.mainBar} = {
          "group/left" = {
            modules = modules-left;
          };
          "group/center" = {
            modules = modules-center;
          };
          "group/right" = {
            modules = modules-right;
          };
          modules-left = ["group/left"];
          modules-center = ["group/center"];
          modules-right = ["group/right"];
          position = "top";
        };

        style = builtins.readFile ./style.css;
      };
    };
}
