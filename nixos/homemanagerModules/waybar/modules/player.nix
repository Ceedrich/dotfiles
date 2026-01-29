{
  pkgs,
  lib,
  config,
  ...
}: let
  wb = config.programs.waybar;
  cfg = wb.modules.player;
in {
  options.programs.waybar.modules.player = {
    name = lib.mkOption {
      type = lib.types.str;
      default = "mpris";
      readOnly = true;
    };
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
  };
  config.programs.waybar = {
    settings = let
    in
      lib.genAttrs cfg.bars (bar: {
        ${cfg.name} = {
          "interval" = 5;
          "format" = "{player_icon} {dynamic}";
          "tooltip-format" = "{player_icon} {dynamic}";
          "dynamic-len" = 30;
          "dynamic-order" = [
            "title"
            "artist"
            "album"
          ];
          "title-len" = 20;
          "player-icons" = {
            "spotify" = "󰓇";
          };
        };
      });
    style =
      #css
      ''
        #${lib.replaceStrings ["/"] ["-"] cfg.name} {}
      '';
  };
}
