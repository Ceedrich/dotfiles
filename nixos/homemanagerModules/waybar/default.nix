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
      # "player" # TODO: look at vanishing modules
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
