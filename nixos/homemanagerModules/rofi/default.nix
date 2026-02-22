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
        display-drun = "Applications";
        modi = "drun,emoji";
        display-emoji = "Emoji";
        hide-scrollbar = true;
      };

      theme = lib.mkForce ./theme.rasi;
    };

    catppuccin.rofi.enable = true;
  };
}
