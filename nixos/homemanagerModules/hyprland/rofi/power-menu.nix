{ pkgs ? import <nixpkgs> { }
, lib ? pkgs.lib
, dmenuCommand ? "${pkgs.rofi-wayland}/bin/rofi -dmenu -i -l 5 -p \"Power Menu\""
, lockCommand ? "loginctl lock-session"
, logoutCommand ? "loginctl kill-session"
, shutdownCommand ? "systemctl poweroff"
, rebootCommand ? "systemctl reboot"
, suspendCommand ? "systemctl suspend"
, ...
}:
let
  join = lib.strings.concatStringsSep;

  options = {
    "󰌾 Lock" = { cmd = lockCommand; confirm = false; };
    "󰍃 Logout" = { cmd = logoutCommand; confirm = true; };
    "󰐥 Shutdown" = { cmd = shutdownCommand; confirm = true; };
    "󰜉 Reboot" = { cmd = rebootCommand; confirm = true; };
    "󰏥 Suspend" = { cmd = suspendCommand; confirm = false; };
  };

  optionList = join "\\n" (builtins.attrNames options);
  optionCases = join "\n" (lib.attrsets.mapAttrsToList
    (name: { cmd, confirm }:
      let
        doConfirm = lib.getExe (import ./confirm-dialogue.nix { inherit pkgs; });
        command = if confirm then "${doConfirm} \"${name}\" \"${cmd}\"" else "${cmd}";
      in
      ''
        "${name}")
        ${command};;
      '')
    options);
in
pkgs.writeShellApplication {
  name = "power-menu";
  text = ''
    chosen=$(echo -e "${optionList}" | ${dmenuCommand})

    case "$chosen" in
      ${optionCases}
    esac
  '';
} 
