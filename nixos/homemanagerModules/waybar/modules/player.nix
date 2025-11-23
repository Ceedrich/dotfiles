{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.programs.waybar.modules.player;
in {
  options.programs.waybar.modules.player = {
    enable = lib.mkOption {
      description = "enable music player module";
      default = true;
      type = lib.types.bool;
    };
    priorities = lib.mkOption {
      description = " Defines the order, players should be targeted in. Only the first available player will work. If none of the specified players is available, the first other player will be used.";
      default = ["spotify" "vlc"];
      type = lib.types.listOf lib.types.str;
    };
    playerCtlPackage = lib.mkPackageOption pkgs "playerctl" {};
  };
  config.programs.waybar = {
    # settings = let
    # in {
    # };
    settings.mainBar = let
      players = "${lib.strings.concatStringsSep "," cfg.priorities},%any";
      playercmd = "${cfg.playerCtlPackage}/bin/playerctl --player='${players}'";

      prev = "custom/music-player-prev";
      main = "custom/music-player-main";
      next = "custom/music-player-next";
    in {
      "group/music-player" = {
        orientation = "inherit";
        modules = [prev main next];
      };
      ${main} = {
        format = "{}";
        interval = 5;
        tooltip = true;
        tooltip-format = "Play/Pause";
        escape = true;
        on-click = "${playercmd} play-pause 2>/dev/null";
        on-click-right = ''hyprctl dispatch focuswindow "class:(?i:^.*$(${playercmd} -l | head -n1).*)"'';
        max-length = 50;
        exec = "${playercmd} metadata --format='{{ artist }} - {{ title }}' 2>/dev/null";
      };
      ${prev} = {
        format = "{icon}";
        format-icons = "󰒮";
        interval = 5;
        tooltip = true;
        tooltip-format = "Previous";
        escape = true;
        max-length = 50;
        on-click = "${playercmd} previous 2>/dev/null";
        exec = "${playercmd} status 2>/dev/null";
      };
      ${next} = {
        format = "{icon}";
        format-icons = "󰒭";
        interval = 5;
        tooltip = true;
        tooltip-format = "Next";
        escape = true;
        max-length = 50;
        on-click = "${playercmd} next 2>/dev/null";
        exec = "${playercmd} status 2>/dev/null";
      };
    };
    style =
      #css
      ''
        #group-music-player {}
        #custom-music-player-prev {}
        #custom-music-player-main {
          padding: 8px;
        }
        #custom-music-player-next {}
      '';
  };
}
