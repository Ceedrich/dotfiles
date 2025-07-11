{ lib, config, pkgs, ... }:
let
  cfg = config.applications.steam;
in
{
  options.applications.steam = {
    enable = lib.mkEnableOption "enable ";
  };
  config = lib.mkIf cfg.enable {
    allowedUnfree = [
      "steam"
      "steam-original"
      "steam-unwrapped"
      "steam-run"
    ];
    programs.steam = {
      enable = true;
      gamescopeSession.enable = true;
    };
    programs.gamemode.enable = true;

    environment.systemPackages = with pkgs; [
      mangohud
    ];
  };
}
