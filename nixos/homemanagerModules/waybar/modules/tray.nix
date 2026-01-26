{
  lib,
  config,
  ...
}: let
  wb = config.programs.waybar;
  cfg = wb.modules.tray;
in {
  options.programs.waybar.modules.tray = {
    name = lib.mkOption {
      type = lib.types.str;
      default = "tray";
      readOnly = true;
    };
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
  config.programs.waybar = lib.mkIf cfg.enable {
    settings = lib.attrsets.genAttrs cfg.bars (bar: {
      "${cfg.name}" = {
        icon-size = 21;
        spacing = 8;
      };
    });
    style =
      #css
      ''
        #${cfg.name} {
            padding: 0px 8px;
        }
      '';
  };
}
