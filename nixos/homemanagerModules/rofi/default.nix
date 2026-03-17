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
      plugins = with pkgs; [
        rofi-emoji
        rofi-nerdy
        rofi-games
      ];
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
        display-nerdy = "Nerd Font Icons";
        modi = "drun,emoji,window,nerdy";
        hide-scrollbar = true;
      };

      theme = ./cofi.rasi;
    };

    xdg.dataFile = {
      "rofi/themes/catppuccin-mocha.rasi".text = config.catppuccin.colorsRasi;
      "rofi/themes/games.rasi".source = ./games.rasi;
    };

    catppuccin.rofi.enable = false;
  };
}
