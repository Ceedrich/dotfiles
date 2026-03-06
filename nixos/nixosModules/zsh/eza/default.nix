{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.programs.eza;
in {
  options.programs.eza = {
    enable = lib.mkEnableOption "eza";
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [pkgs.eza];
    environment.shellAliases = {
      ls = "eza";
      ll = "eza -l";
      la = "eza -a";
      lt = "eza --tree";
      lla = "eza -la";
    };
  };
}
