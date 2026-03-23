{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.homelab.backup;
in {
  options.homelab.backup = let
    inherit (lib) mkEnableOption mkOption types;
  in {
    enable = mkEnableOption "backup";
    paths = mkOption {
      type = types.listOf types.path;
      description = "All the paths to back up";
      default = [];
    };
    user = mkOption {
      type = types.str;
      description = "User to run the backup as";
      default = "root";
    };
    repository = mkOption {
      type = types.str;
      description = "repository to backup to.";
    };
  };
  config = lib.mkIf cfg.enable {
    services.restic.backups.default = {
      user = cfg.user;
      passwordFile = builtins.toFile "blub" ''password'';
      repository = cfg.repository;
      paths = cfg.paths;
      initialize = true;
    };
  };
}
