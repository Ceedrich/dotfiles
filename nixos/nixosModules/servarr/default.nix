{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.services.servarr;
in {
  options.services.servarr = let
    inherit (lib) types mkOption;
    mkPortOption = name: default:
      mkOption {
        type = types.int;
        description = "port for ${name}";
        inherit default;
      };
  in {
    enable = lib.mkEnableOption "Arr Stack";

    dataDir = mkOption {
      type = types.path;
      description = "data dir";
      default = "/var/lib/servarr";
    };

    directories = {
      mediaDir = mkOption {
        type = types.path;
        description = "directory where all media lives";
        default = "/media-server";
      };
      moviesDir = mkOption {
        type = types.path;
        description = "directory for movies";
        defaultText = lib.literalExpression ''''${config.services.servarr.mediaDir}/movies'';
        default = "${cfg.mediaDir}/movies";
      };
      showsDir = mkOption {
        type = types.path;
        description = "directory for tv shows";
        defaultText = lib.literalExpression ''''${config.services.servarr.mediaDir}/tv-shows'';
        default = "${cfg.mediaDir}/tv-shows";
      };
    };

    prowlarr = {
      port = mkPortOption "Prowlarr" 9000;
    };
    sonarr = {
      port = mkPortOption "Sonarr" 9001;
    };
    radarr = {
      port = mkPortOption "Radarr" 9002;
    };
    deluge = {
      web.port = mkPortOption "Deluge Web" 9011;
    };

    user = mkOption {
      type = types.str;
      default = "servarr";
    };
    group = mkOption {
      type = types.str;
      default = "servarr";
    };
  };

  config = lib.mkIf cfg.enable {
    users = {
      groups.${cfg.group} = {};
      users.${cfg.user} = {
        isSystemUser = true;
        group = cfg.group;
        home = cfg.dataDir;
      };
    };

    services.deluge = {
      user = cfg.user;
      group = cfg.group;
      dataDir = "${cfg.dataDir}/deluge";

      enable = true;
      declarative = true;
      web = {
        port = cfg.deluge.web.port;
        enable = true;
      };
      config = {
        max_upload_speed = "0.0";
        max_upload_slots_global = 0;
      };
      authFile = pkgs.writeTextFile {
        name = "deluge-credentials";
        text = "localclient:admin:10";
      };
    };
    services.sonarr = {
      user = cfg.user;
      group = cfg.group;
      dataDir = "${cfg.dataDir}/sonarr";

      settings = {
        server.port = cfg.sonarr.port;
        auth.enabled = false;
      };
      enable = true;
    };
    services.prowlarr = {
      dataDir = "${cfg.dataDir}/prowlarr";

      settings = {
        server.port = cfg.prowlarr.port;
        auth.enabled = false;
      };
      enable = true;
    };
    services.radarr = {
      user = cfg.user;
      group = cfg.group;
      dataDir = "${cfg.dataDir}/radarr";

      settings = {
        server.port = cfg.radarr.port;
        auth.enabled = false;
      };
      enable = true;
    };
  };
}
