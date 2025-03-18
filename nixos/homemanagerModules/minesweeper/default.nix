{ pkgs, inputs, lib, config, ... }:

{
  options = {
    minesweeper.enable = lib.mkEnableOption "enable minesweeper";
  };
  config = lib.mkIf config.minesweeper.enable {
    home.packages = [
      (pkgs.gnome-mines.overrideAttrs {
        src = inputs.gnome-mines-custom;
      })
    ];
  };
}
