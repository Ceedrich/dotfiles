{
  lib,
  config,
  ...
}: let
  wb = config.programs.waybar;
  cfg = wb.modules.idle_inhibitor;
in {
  options.programs.waybar.modules.idle_inhibitor = {
    name = lib.mkOption {
      type = lib.types.str;
      default = "idle_inhibitor";
      readOnly = true;
    };
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
      "${cfg.name}" = {
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
        #${cfg.name} {
          border-bottom: 2px solid;
        }
      '';
  };
}
