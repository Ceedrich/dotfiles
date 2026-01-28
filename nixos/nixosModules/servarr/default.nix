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
  };

  config = lib.mkIf cfg.enable {
    services.deluge = {
      enable = true;
      declarative = true;
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
      settings = {
        server.port = cfg.sonarr.port;
        auth.enabled = false;
      };
      enable = true;
    };
    services.prowlarr = {
      settings = {
        server.port = cfg.prowlarr.port;
        auth.enabled = false;
      };
      enable = true;
    };
    services.radarr = {
      settings = {
        server.port = cfg.radarr.port;
        auth.enabled = false;
      };
      enable = true;
    };
  };
}
