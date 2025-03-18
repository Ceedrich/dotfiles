{ pkgs, lib, config, ... }:

{
  options = {
    discord-unfree.enable = lib.mkEnableOption "enable discord-unfree";
  };
  config = lib.mkIf config.discord-unfree.enable {
    home.packages = with pkgs; [ discord ];
    allowedUnfree = [ "discord" ];
  };
}
