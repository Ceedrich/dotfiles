{ pkgs, lib, config, ... }:

{
  options = {
    rofi.enable = lib.mkEnableOption "enable rofi";
  };
  config = lib.mkIf config.rofi.enable {
    programs.rofi = {
      enable = true;
      plugins = with pkgs; [ rofi-emoji ];
      terminal = "${pkgs.ghostty}/bin/ghostty";
      extraConfig = {
        kb-row-down = "Control+j";
        kb-row-up = "Control+k";
        kb-remove-to-eol = "";
        kb-accept-entry = "Return";
        display-drun = "Applications";
        modi = "drun,emoji";
        display-emoji = "Emoji";
        hide-scrollbar = true;
      };

      theme =
        let
          lit = config.lib.formats.rasi.mkLiteral;
        in
        {
          "*" = {
            selected-normal-background = lit "@mauve";
            font = "JetBrains Mono Nerd Font 14";
          };
          entry.placeholder = "";
          prompt = {
            text-style = lit "bold";
          };
          window = {
            border = lit "0.2em";
            border-radius = lit "0.5em";
            border-color = lit "@mauve";
          };
          element-icon = { size = lit "1em"; };
          element-text = { vertical-align = lit "0.5"; };
        };
    };

    catppuccin.rofi.enable = true;
  };
}
