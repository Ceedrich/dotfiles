{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.programs.spotify;
in {
  options.programs.spotify = {
    enable = lib.mkEnableOption "enable Spotify";
  };
  config = lib.mkIf cfg.enable {
    allowedUnfree = [
      "spotify"
    ];
    home.packages = with pkgs; [
      spotify
    ];
  };
}
