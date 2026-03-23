{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.programs.steam;
in {
  config = lib.mkIf cfg.enable {
    allowedUnfree = [
      "steam"
      "steam-original"
      "steam-unwrapped"
      "steam-run"
    ];
    programs.steam = {
      gamescopeSession.enable = true;
    };
    programs.gamemode.enable = true;

    environment.systemPackages = with pkgs; [
      mangohud
    ];
  };
}
