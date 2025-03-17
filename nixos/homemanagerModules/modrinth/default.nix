{ pkgs, lib, config, ... }:

{
  options = {
    modrinth.enable = lib.mkEnableOption "enable modrinth";
  };
  config = lib.mkIf config.modrinth.enable {
    home.packages = with pkgs; [ modrinth-app ];
  };
}
