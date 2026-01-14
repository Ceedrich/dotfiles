{
  lib,
  config,
  ...
}: let
  wb = config.services.waybar;
  cfg = wb.modules.minimized;
in {
  options.services.waybar.modules.minimized = {
    enable = lib.mkOption {
      description = "minimized";
      default = true;
      type = lib.types.bool;
    };
    bars = lib.mkOption {
      default = [wb.mainBar];
      type = lib.types.listOf lib.types.str;
      description = "The names of the bars to add the module to";
    };
  };
  config.services.waybar = {
    settings = let
    in
      lib.genAttrs cfg.bars (bar: {
        "custom/minimized" = {
          "format" = "";
          "on-click" = "hyprctl --batch 'dispatch submap reset; dispatch workspace special:minimized; dispatch submap minimized'";
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
