{ pkgs ? import <nixpkgs> { }
, lib ? pkgs.lib
, dmenuCommand ? "${pkgs.rofi-wayland}/bin/rofi -dmenu -i"
, lockCommand ? "${pkgs.hyprlock}/bin/hyprlock"
, logoutCommand ? "${pkgs.hyprland}/bin/hyprctl dispatch exit"
, shutdownCommand ? "poweroff"
, rebootCommand ? "reboot"
, suspendCommand ? "systemctl suspend"
, ...
}:
let
  join = lib.strings.concatStringsSep;

  options = {
    "󰌾 Lock" = lockCommand;
    "󰍃 Logout" = logoutCommand;
    "󰐥 Shutdown" = shutdownCommand;
    "󰜉 Reboot" = rebootCommand;
    "󰏥 Suspend" = suspendCommand;
  };

  optionList = join "\\n" (builtins.attrNames options);
  optionCases = join "\n" (lib.attrsets.mapAttrsToList
    (name: command: ''
      "${name}")
      ${command};;
    '')
    options);
in
pkgs.writeShellScript "power-menu" ''
  chosen=$(echo -e "${optionList}" | ${dmenuCommand})

  case "$chosen" in
    ${optionCases}
  esac
''
