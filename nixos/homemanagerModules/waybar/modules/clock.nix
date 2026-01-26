{
  lib,
  config,
  ...
}: let
  wb = config.programs.waybar;
  cfg = wb.modules.clock;
in {
  options.programs.waybar.modules.clock = {
    name = lib.mkOption {
      type = lib.types.str;
      default = "clock";
      readOnly = true;
    };
    enable = lib.mkOption {
      description = "enable clock module";
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
        format = "{:%d.%m.%Y | %H:%M}";
        interval = 1;
        tooltip-format = "<tt><small>{calendar}</small></tt>";
        calendar = {
          mode = "month";
          weeks-pos = "left";
          on-scroll = 1;
          format = {
            months = "<b>{}</b>";
            weeks = ''<span color="#6c7086">{}</span>'';
            weekdays = "<b>{}</b>";
            days = "<b>{}</b>";
            today = ''<span color="#cba6f7"><b>{}</b></span>'';
          };
        };
      };
    });
    style =
      #css
      ''
        #${cfg.name} {
            color: @overlay0;
        }
      '';
  };
}
