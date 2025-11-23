{lib, ...}: {
  options.programs.waybar.modules.idle_inhibitor = {
    enable = lib.mkOption {
      description = "enable idle_inhibitor module";
      default = true;
      type = lib.types.bool;
    };
  };
  config.programs.waybar = {
    settings.mainBar."idle_inhibitor" = {
      format = "{icon}";
      format-icons = {
        activated = "󰈈";
        deactivated = "󰈉";
      };
      tooltip-format-activated = "Staying Awake";
      tooltip-format-deactivated = "Idling Enabled";
    };
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
