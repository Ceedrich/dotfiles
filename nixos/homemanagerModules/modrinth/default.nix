{ pkgs, lib, config, ... }:

{
  options = {
    modrinth-unfree.enable = lib.mkEnableOption "enable modrinth";
  };
  config = lib.mkIf config.modrinth-unfree.enable {
    allowedUnfree = [
      "modrinth-app"
      "modrinth-app-unwrapped"
    ];
    home.packages = with pkgs; [ modrinth-app ];
  };
}
