{ pkgs, lib, config, ... }:

{
  options = {
    modrinth.enable = lib.mkEnableOption "enable modrinth";
  };
  config = lib.mkIf config.modrinth.enable {
    allowedUnfree = [
      "modrinth-app"
      "modrinth-app-unwrapped"
    ];
    home.packages = with pkgs; [ modrinth-app ];
  };
}
