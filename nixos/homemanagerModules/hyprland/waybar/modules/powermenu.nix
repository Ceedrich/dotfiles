{
  lib,
  callPackage,
}: let
  poweroff = "custom/poweroff";
  logout = "custom/logout";
  lock = "custom/lock";
  reboot = "custom/reboot";

  confirm-dialogue = callPackage ../../rofi/confirm-dialogue.nix {};
  doConfirm = lib.getExe confirm-dialogue;
in rec {
  name = "group/powermenu";
  settings = {
    ${name} = {
      orientation = "inherit";
      drawer = {
        transition-duration = 500;
        children-class = "not-power";
        # BUG: See https://github.com/Alexays/Waybar/issues/4382
        on-scroll-up = "true";
        on-scroll-down = "true";
      };
      modules = [poweroff logout lock reboot];
    };

    ${poweroff} = {
      format = "󰐥";
      tooltip-format = "Logout";
      on-click = "${doConfirm} \"Logout\" \"hyprctl dispatch exit\"";
      # BUG: See https://github.com/Alexays/Waybar/issues/4382
      on-scroll-up = "true";
      on-scroll-down = "true";
    };
    ${logout} = {
      format = "󰍃";
      tooltip-format = "Logout";
      on-click = "${doConfirm} \"Logout\" \"hyprctl dispatch exit\"";
      # BUG: See https://github.com/Alexays/Waybar/issues/4382
      on-scroll-up = "true";
      on-scroll-down = "true";
    };
    ${lock} = {
      format = "󰌾";
      tooltip-format = "Lock";
      on-click = "hyprlock";
      # BUG: See https://github.com/Alexays/Waybar/issues/4382
      on-scroll-up = "true";
      on-scroll-down = "true";
    };
    ${reboot} = {
      format = "󰜉";
      tooltip-format = "Reboot";
      on-click = "${doConfirm} \"Reboot\" \"reboot\"";
      # BUG: See https://github.com/Alexays/Waybar/issues/4382
      on-scroll-up = "true";
      on-scroll-down = "true";
    };
  };
  style =
    #css
    ''
      #custom-poweroff,
      #custom-logout,
      #custom-lock,
      #custom-reboot {
        color: @blue;
        padding: 8px;
      }

    '';
}
