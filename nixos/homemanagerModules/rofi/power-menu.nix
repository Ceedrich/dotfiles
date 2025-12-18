{
  dmenuCommand ? "${lib.getExe rofi} -dmenu -i -l 5 -p \"Power Menu\"",
  lockCommand ? "loginctl lock-session self",
  logoutCommand ? "loginctl kill-session self",
  shutdownCommand ? "systemctl poweroff",
  rebootCommand ? "systemctl reboot",
  suspendCommand ? "systemctl suspend",
  lib,
  callPackage,
  writeShellApplication,
  rofi,
}: let
  join = lib.strings.concatStringsSep;

  options = {
    "󰌾 Lock" = {
      cmd = lockCommand;
      confirm = false;
    };
    "󰍃 Logout" = {
      cmd = logoutCommand;
      confirm = true;
    };
    "󰐥 Shutdown" = {
      cmd = shutdownCommand;
      confirm = true;
    };
    "󰜉 Reboot" = {
      cmd = rebootCommand;
      confirm = true;
    };
    "󰏥 Suspend" = {
      cmd = suspendCommand;
      confirm = false;
    };
  };

  optionList = join "\\n" (builtins.attrNames options);
  optionCases = join "\n" (lib.attrsets.mapAttrsToList
    (name: {
      cmd,
      confirm,
    }: let
      doConfirm = lib.getExe (callPackage ./confirm-dialogue.nix {});
      command =
        if confirm
        then "${doConfirm} \"${name}\" \"${cmd}\""
        else "${cmd}";
    in ''
      "${name}")
      ${command};;
    '')
    options);
in
  writeShellApplication {
    name = "power-menu";
    text = ''
      chosen=$(echo -e "${optionList}" | ${dmenuCommand})

      case "$chosen" in
        ${optionCases}
      esac
    '';
  }
