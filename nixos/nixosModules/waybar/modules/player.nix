{
  ceedrichPkgs,
  pkgs,
  lib,
  config,
  ...
}: let
  wb = config.services.waybar;
  cfg = wb.modules.player;
in {
  options.services.waybar.modules.player = {
    enable = lib.mkOption {
      description = "enable music player module";
      default = true;
      type = lib.types.bool;
    };
    bars = lib.mkOption {
      default = [wb.mainBar];
      type = lib.types.listOf lib.types.str;
      description = "The names of the bars to add the module to";
    };
    priorities = lib.mkOption {
      description = " Defines the order, players should be targeted in. Only the first available player will work. If none of the specified players is available, the first other player will be used.";
      default = ["spotify" "vlc"];
      type = lib.types.listOf lib.types.str;
    };
    playerCtlPackage = lib.mkPackageOption pkgs "playerctl" {};
  };
  config.services.waybar = {
    settings = let
      players = "${lib.strings.concatStringsSep "," cfg.priorities},%any";
      playercmd = "${ceedrichPkgs.waybar-player}/bin/waybar-player -p='${players}'";

      prev = "custom/music-player-prev";
      main = "custom/music-player-main";
      next = "custom/music-player-next";
    in
      lib.genAttrs cfg.bars (bar: {
        "group/music-player" = {
          orientation = "inherit";
          modules = [prev main next];
        };
        ${main} = {
          format = "{text}";
          interval = 5;
          tooltip = true;
          return-type = "json";
          escape = true;
          on-click = "${playercmd} play-pause";
          on-click-right = ''${playercmd} open'';
          max-length = 50;
          exec = "${playercmd} show";
          # BUG: See https://github.com/Alexays/Waybar/issues/4382
          on-scroll-up = "true";
          on-scroll-down = "true";
        };
        ${prev} = {
          format = "{icon}";
          format-icons = "󰒮";
          interval = 5;
          tooltip = true;
          tooltip-format = "Previous";
          escape = true;
          max-length = 50;
          on-click = "${playercmd} prev 2";
          exec = "${playercmd} status 2";
          # BUG: See https://github.com/Alexays/Waybar/issues/4382
          on-scroll-up = "true";
          on-scroll-down = "true";
        };
        ${next} = {
          format = "{icon}";
          format-icons = "󰒭";
          interval = 5;
          tooltip = true;
          tooltip-format = "Next";
          escape = true;
          max-length = 50;
          on-click = "${playercmd} next";
          exec = "${playercmd} status";
          # BUG: See https://github.com/Alexays/Waybar/issues/4382
          on-scroll-up = "true";
          on-scroll-down = "true";
        };
      });
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
