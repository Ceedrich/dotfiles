{
  pkgs ? import <nixpkgs>,
  lib ? pkgs.lib,
  name ? "group/powermenu",
}: let
  poweroff = "custom/poweroff";
  logout = "custom/logout";
  lock = "custom/lock";
  reboot = "custom/reboot";

  doConfirm = lib.getExe (import ../../rofi/confirm-dialogue.nix {inherit pkgs;});
in {
  ${name} = {
    orientation = "inherit";
    drawer = {
      transition-duration = 500;
      children-class = "not-power";
    };
    modules = [poweroff logout lock reboot];
  };

  ${poweroff} = {
    format = "󰐥";
    tooltip-format = "Logout";
    on-click = "${doConfirm} \"Logout\" \"hyprctl dispatch exit\"";
  };
  ${logout} = {
    format = "󰍃";
    tooltip-format = "Logout";
    on-click = "${doConfirm} \"Logout\" \"hyprctl dispatch exit\"";
  };
  ${lock} = {
    format = "󰌾";
    tooltip-format = "Lock";
    on-click = "hyprlock";
  };
  ${reboot} = {
    format = "󰜉";
    tooltip-format = "Reboot";
    on-click = "${doConfirm} \"Reboot\" \"reboot\"";
  };
}
