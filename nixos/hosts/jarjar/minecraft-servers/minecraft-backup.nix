{
  pkgs,
  config,
  lib,
  ...
}: let
  mc-cfg = config.services.minecraft-servers;
  cfg = mc-cfg.backups;
  restic-passwd = "restic";
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
    rcon = {
      port = lib.mkOption {
        type = lib.types.int;
        default = 25575;
      };
      password = lib.mkOption {
        type = lib.types.str;
        default = "minecraft";
      };
    };
  };
  config = let
    # eachServer = f: lib.mapAttrs' f mc-cfg.servers;
    eachServer = f: lib.foldl' lib.recursiveUpdate {} (lib.mapAttrsToList f mc-cfg.servers);
  in
    lib.mkIf cfg.enable {
      assertions =
        [
          # TODO: verify rcon is enabled for all servers
        ]
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
        port = toString (server.serverProperties.rcon-port or cfg.rcon.port);
        password = server.serverProperties."rcon.password";
      in {
        "minecraft-backup-${name}" = {
          description = "Run backup script for '${name}'";
          serviceConfig = {
            Type = "oneshot";
            ExecStart = let
              backup-cmd = "${pkgs.callPackage ../../../packages/minecraft-backup.nix {}}/bin/minecraft-backup";
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
        "minecraft-backup-restic-${name}" = {
          description = "Run backup script for '${name}'";
          environment = { RESTIC_PASSWORD = restic-passwd; };
          serviceConfig = {
            Type = "oneshot";
            ExecStart = let
              backup-cmd = "${pkgs.callPackage ../../../packages/minecraft-backup.nix {}}/bin/minecraft-backup";
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
