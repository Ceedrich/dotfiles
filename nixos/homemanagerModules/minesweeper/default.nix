# ERROR: Currently broken
{
  pkgs,
  inputs,
  lib,
  config,
  ...
}: let
  cfg = config.programs.minesweeper;
in {
  options.programs.minesweeper = {
    enable = lib.mkEnableOption "enable Minesweeper";
  };
  config = lib.mkIf cfg.enable {
    home.packages = [
      (pkgs.gnome-mines.overrideAttrs {
        src = inputs.gnome-mines-custom;
      })
    ];
  };
}
