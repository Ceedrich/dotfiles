{
  lib,
  config,
  ...
}: let
  wb = config.services.waybar;
  cfg = config.services.waybar.modules.workspaces;
in {
  options.services.waybar.modules.workspaces = {
    enable = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "enable workspaces module";
    };
    bars = lib.mkOption {
      default = [wb.mainBar];
      type = lib.types.listOf lib.types.str;
      description = "The names of the bars to add the module to";
    };
  };

  config = lib.mkIf cfg.enable {
    services.waybar.settings = lib.attrsets.genAttrs cfg.bars (
      bar: {}
    );

    services.waybar.style =
      lib.mkIf cfg.enable
      #css
      ''
        #workspaces button {
          border-radius: 0;
          border: none;
          color: @overlay0;
          padding: 0px 4px;
          margin: 2px 4px;
        }

        #workspaces button.active,
        #workspaces button.focused {
          color: @mauve;
          border-bottom: 2px solid;
        }

        #workspaces button.urgent {
          background-color: @red;
          border-bottom: 2px solid;
        }
      '';
  };
}
