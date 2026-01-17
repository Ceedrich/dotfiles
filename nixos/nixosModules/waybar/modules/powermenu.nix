{
  lib,
  config,
  ceedrichPkgs,
  ...
}: let
  name = "group/powermenu";

  poweroff = "custom/powermenu-poweroff";
  logout = "custom/powermenu-logout";
  lock = "custom/powermenu-lock";
  reboot = "custom/powermenu-reboot";
  suspend = "custom/powermenu-suspend";

  mkConfirm = label: cmd: ''${lib.getExe ceedrichPkgs.rofi-confirm-dialogue} "${label}" "${cmd}"'';
  wb = config.services.waybar;
  cfg = wb.modules.powermenu;
in {
  options.services.waybar.modules.powermenu = {
    enable = lib.mkOption {
      description = "enable powermenu module";
      default = true;
      type = lib.types.bool;
    };
    bars = lib.mkOption {
      default = [wb.mainBar];
      type = lib.types.listOf lib.types.str;
      description = "The names of the bars to add the module to";
    };
    shutdownCommand = lib.mkOption {
      default = "systemctl poweroff";
      type = lib.types.str;
    };
    logoutCommand = lib.mkOption {
      default = "loginctl kill-session";
      type = lib.types.str;
    };
    rebootCommand = lib.mkOption {
      default = "systemctl reboot";
      type = lib.types.str;
    };
    lockCommand = lib.mkOption {
      default = "loginctl lock-session";
      type = lib.types.str;
    };
    suspendCommand = lib.mkOption {
      default = "${cfg.lockCommand}; systemctl suspend";
      type = lib.types.str;
    };
  };
  config.services.waybar = lib.mkIf cfg.enable {
    settings = lib.genAttrs cfg.bars (bar: {
      ${name} = {
        orientation = "inherit";
        drawer = {
          transition-duration = 500;
          children-class = "not-power";
          # BUG: See https://github.com/Alexays/Waybar/issues/4382
          on-scroll-up = "true";
          on-scroll-down = "true";
        };
        modules = [poweroff logout lock suspend reboot];
      };

      ${poweroff} = rec {
        format = "󰐥";
        tooltip-format = "Poweroff";
        on-click = mkConfirm "${format} ${tooltip-format}" cfg.shutdownCommand;
        # BUG: See https://github.com/Alexays/Waybar/issues/4382
        on-scroll-up = "true";
        on-scroll-down = "true";
      };
      ${suspend} = {
        format = "󰏥";
        tooltip-format = "Suspend";
        on-click = cfg.suspendCommand;
        on-scroll-up = "true";
        on-scroll-down = "true";
      };
      ${logout} = rec {
        format = "󰍃";
        tooltip-format = "Logout";
        on-click = mkConfirm "${format} ${tooltip-format}" cfg.logoutCommand;
        # BUG: See https://github.com/Alexays/Waybar/issues/4382
        on-scroll-up = "true";
        on-scroll-down = "true";
      };
      ${lock} = {
        format = "󰌾";
        tooltip-format = "Lock";
        on-click = cfg.lockCommand;
        # BUG: See https://github.com/Alexays/Waybar/issues/4382
        on-scroll-up = "true";
        on-scroll-down = "true";
      };
      ${reboot} = rec {
        format = "󰜉";
        tooltip-format = "Reboot";
        on-click = mkConfirm "${format} ${tooltip-format}" cfg.rebootCommand;
      };
    });
    style =
      #css
      ''
        #custom-powermenu-poweroff,
        #custom-powermenu-logout,
        #custom-powermenu-lock,
        #custom-powermenu-reboot,
        #custom-powermenu-suspend {
          color: @blue;
          padding: 0px 8px;
        }

        #custom-powermenu-poweroff:hover,
        #custom-powermenu-logout:hover,
        #custom-powermenu-lock:hover,
        #custom-powermenu-reboot:hover {
          border-bottom: 2px solid;
        }

      '';
  };
}
