{
  lib,
  config,
  ...
}: let
  wb = config.services.waybar;
  cfg = wb.modules.tray;
in {
  options.services.waybar.modules.tray = {
    enable = lib.mkOption {
      description = "enable tray module";
      default = true;
      type = lib.types.bool;
    };
    bars = lib.mkOption {
      default = [wb.mainBar];
      type = lib.types.listOf lib.types.str;
      description = "The names of the bars to add the module to";
    };
  };
  config.services.waybar = lib.mkIf cfg.enable {
    settings = lib.attrsets.genAttrs cfg.bars (bar: {
      "tray" = {
        icon-size = 21;
        spacing = 8;
      };
    });
    style =
      #css
      ''
        #tray {
            padding: 0px 8px;
        }
      '';
  };
}
