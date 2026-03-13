{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.programs.rofi;
in {
  config = {
    programs.rofi = lib.mkIf cfg.enable {
      plugins = with pkgs; [rofi-emoji];
      terminal = "${pkgs.ghostty}/bin/ghostty";
      extraConfig = {
        kb-row-down = "Down,Control+j";
        kb-row-up = "Up,Control+k";
        kb-remove-to-eol = "";
        kb-accept-entry = "Return";
        me-select-entry = "";
        me-accept-entry = "MousePrimary";
        display-drun = "Applications";
        display-window = "Windows";
        display-emoji = "Emoji";
        modi = "drun,emoji,window";
        hide-scrollbar = true;
      };

      theme = ./cofi.rasi;
    };

    xdg.dataFile = {
      "rofi/themes/catppuccin-mocha.rasi".text = config.catppuccin.colorsRasi;
    };

    catppuccin.rofi.enable = false;
  };
}
