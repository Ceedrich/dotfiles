{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.programs.discord;
in {
  options.programs.discord = {
    enable = lib.mkEnableOption "enable Discord";
  };
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [discord];
    allowedUnfree = ["discord"];
  };
}
