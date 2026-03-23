{lib, ...}: let
  mkCmdOption = default:
    lib.mkOption {
      type = lib.types.str;
      inherit default;
    };
in {
  options.logoutCommands = {
    shutdown = mkCmdOption "systemctl poweroff";
    reboot = mkCmdOption "systemctl reboot";
    logout = mkCmdOption "loginctl kill-session ''";
    lock = mkCmdOption "loginctl lock-session";
    suspend = mkCmdOption "systemctl suspend";
  };
}
