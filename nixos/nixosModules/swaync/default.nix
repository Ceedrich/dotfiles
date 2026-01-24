{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.services.swaync;
in {
  options.services.swaync = let
    inherit (lib) types mkEnableOption;
  in {
    enable = mkEnableOption "enable ";
    package = lib.mkPackageOption pkgs "swaynotificationcenter" {};
    extraPackages = lib.mkOption {
      type = types.listOf types.package;
      default = [
        pkgs.hyprpicker
      ];
    };
  };

  config = lib.mkIf cfg.enable {
    services.gvfs.enable = true; # See <https://github.com/NixOS/nixpkgs/issues/340623>
    environment.systemPackages = cfg.extraPackages;

    global-hm.config.catppuccin.swaync.enable = false; # We set our custom theme
    global-hm.config.services.swaync = {
      enable = true;
      package = cfg.package;
      settings = {
        "$schema" = "https://raw.githubusercontent.com/ErikReider/SwayNotificationCenter/refs/heads/main/src/configSchema.json";
        control-center-height = -1;
        control-center-margin-right = 16;
        control-center-margin-top = 16;
        control-center-positionY = "top";
        fit-to-screen = false;
        positionX = "right";
        positionY = "top";
        widget-config = {
          backlight = {label = "󰛩";};
          dnd = {text = "Do Not Disturb";};
          buttons-grid = {
            actions = [
              {
                label = "󰈊";
                command = "hyprpicker -aq";
              }
            ];
          };
          menubar = {
            "menu#power-buttons" = {
              actions = [
                {
                  command = "systemctl reboot";
                  label = "   Reboot";
                }
                {
                  command = "swaync-client -cp; hyprlock";
                  label = "   Lock";
                }
                {
                  command = "loginctl terminate-session \${XDG_SESSION_ID-}";
                  label = "   Logout";
                }
                {
                  command = "systemctl poweroff";
                  label = "   Shut down";
                }
              ];
              label = "";
              position = "right";
            };
          };
          mpris = {
            autohide = true;
            blacklist = ["brave"];
            loop-carousel = false;
            show-album-art = "when-available";
          };
          title = {text = "Notifications";};
          volume = {
            empty-list-label = "No active apps";
            label = "󰕾";
            show-per-app = true;
            show-per-app-label = true;
          };
        };
        widgets = [
          "menubar"
          "buttons-grid"
          "inhibitors"
          "mpris"
          "volume"
          "backlight"
          "title"
          "dnd"
          "notifications"
        ];
      };
      style = ''
        @import "${./colors.css}";
        ${lib.readFile ./style.css}
      '';
    };
  };
}
