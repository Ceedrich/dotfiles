{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.programs.sesh;
in {
  options.programs.sesh = {
    enable = lib.mkEnableOption "Sesh";
    package = lib.mkPackageOption pkgs "sesh" {};
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [cfg.package];
    environment.shellAliases = {
      "s" = "sesh connect $(sesh list | fzf)";
    };

    home-manager.sharedModules = [
      ({...}: {
        programs.sesh = {
          enable = true;
        };
        programs.fzf.tmux.enableShellIntegration = true;
      })
    ];
  };
}
