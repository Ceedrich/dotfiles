{
  config,
  lib,
  ceedrichPkgs,
  ...
}: let
  cfg = config.programs.power-menu;
in {
  options.programs.power-menu = {
    enable = lib.mkEnableOption "Power Menu" // {default = true;};
    package = lib.mkOption {
      type = lib.types.package;
      default = let
        commands = config.logoutCommands;
      in
        ceedrichPkgs.power-menu.override {
          lockCommand = commands.lock;
          logoutCommand = commands.logout;
          shutdownCommand = commands.shutdown;
          rebootCommand = commands.reboot;
          suspendCommand = commands.suspend;
        };
    };
  };
  config = {
    environment.systemPackages = [cfg.package];
  };
}
