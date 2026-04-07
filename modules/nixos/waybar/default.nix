{self, ...}: {
  flake.nixosModules.waybar = {
    home-manager.sharedModules = with self.homeModules; [waybar];
  };

  flake.homeModules.waybar = {
    lib,
    config,
    ...
  }: let
    cfg = config.programs.waybar;
  in {
    imports = [
      ./_modules
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
              orientation = "inherit";
              modules = modules-left;
            };
            "group/center" = {
              orientation = "inherit";
              modules = modules-center;
            };
            "group/right" = {
              orientation = "inherit";
              modules = modules-right;
            };
            modules-left = ["group/left"];
            modules-center = ["group/center"];
            modules-right = ["group/right"];
            position = "top";
          };

          style = builtins.readFile ./_style.css;
        };
      };
  };
}
