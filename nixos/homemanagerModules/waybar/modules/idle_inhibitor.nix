{
  lib,
  config,
  ...
}: let
  wb = config.programs.waybar;
  cfg = wb.modules.idle_inhibitor;
in {
  options.programs.waybar.modules.idle_inhibitor = {
    enable = lib.mkOption {
      description = "enable idle_inhibitor module";
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
    settings = lib.genAttrs cfg.bars (bar: {
      "idle_inhibitor" = {
        format = "{icon}";
        format-icons = {
          activated = "󰈈";
          deactivated = "󰈉";
        };
        tooltip-format-activated = "Staying Awake";
        tooltip-format-deactivated = "Idling Enabled";
      };
    });
    style =
      /*
      css
      */
      ''
        #idle_inhibitor {
          border-bottom: 2px solid;
        }
      '';
  };
}
