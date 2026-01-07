{
  ceedrichPkgs,
  config,
  lib,
  pkgs,
  ...
}: let
  mc-cfg = config.services.minecraft-servers;
  cfg = mc-cfg.backups;
in {
  options.services.minecraft-servers.backups = {
    enable = lib.mkEnableOption "enable minecraft server backups" // {default = true;};
    dir = lib.mkOption {
      type = lib.types.path;
      default = "${mc-cfg.dataDir}/backups";
    };
    times = lib.mkOption {
      type = lib.types.str;
      default = "04:00";
    };
    restic = {
      enable = lib.mkEnableOption "enable restic backup" // {default = true;};
      password = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
      };
    };
  };
  config = let
    eachServer = f: lib.foldl' lib.recursiveUpdate {} (lib.mapAttrsToList f mc-cfg.servers);
  in
    lib.mkIf cfg.enable {
      assertions =
        lib.mapAttrsToList (name: server: {
          assertion = !cfg.restic.enable || cfg.restic.password != null;
          message = ''`restic.password` must be set'';
        })
        mc-cfg.servers
        ++ lib.mapAttrsToList (name: server: {
          assertion = let
            prop = server.serverProperties;
          in
            (prop.enable-rcon or false)
            && (prop."rcon.password" or "") != "";
          message = ''In order to use the backup, rcon must be enabled with a set password'';
        })
        mc-cfg.servers;
      systemd.timers = eachServer (name: server: {
        "minecraft-backup-${name}" = {
          wantedBy = ["timers.target"];
          timerConfig = {
            OnCalendar = "${cfg.times}";
          };
        };
        "minecraft-backup-restic-${name}" = {
          wantedBy = ["timers.target"];
          timerConfig = {
            OnCalendar = "${cfg.times}";
          };
        };
      });
      systemd.services = eachServer (name: server: let
        port = toString (server.serverProperties.rcon-port or 25575);
        password = server.serverProperties."rcon.password";
      in {
        "minecraft-backup-${name}" = {
          description = "Run backup script for '${name}'";
          serviceConfig = {
            Type = "oneshot";
            ExecStart = let
              backup-cmd = "${ceedrichPkgs.minecraft-backup}/bin/minecraft-backup";
            in ''
              ${backup-cmd} -c \
                -i ${mc-cfg.dataDir}/${name}/world \
                -o ${cfg.dir}/${name} \
                -s localhost:${port}:${password} \
                -w rcon
            '';
            User = mc-cfg.user;
            Group = mc-cfg.group;
          };
        };
        "minecraft-backup-restic-${name}" = lib.mkIf cfg.restic.enable {
          description = "Run backup script for '${name}'";
          environment = {RESTIC_PASSWORD = cfg.restic.password;};
          serviceConfig = {
            Type = "oneshot";
            ExecStart = let
              backup-cmd = "${ceedrichPkgs.minecraft-backup}/bin/minecraft-backup";
            in ''
              ${backup-cmd} -c \
                -i ${mc-cfg.dataDir}/${name}/world \
                -r ${cfg.dir}-restic/${name} \
                -s localhost:${port}:${password} \
                -w rcon
            '';
            User = mc-cfg.user;
            Group = mc-cfg.group;
          };
        };
      });
    };
}
