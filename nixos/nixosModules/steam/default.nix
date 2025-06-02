{ pkgs, lib, config, ... }: {
  options = {
    steam-unfree.enable = lib.mkEnableOption "enable steam";
  };
  config = lib.mkIf config.steam-unfree.enable {
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
