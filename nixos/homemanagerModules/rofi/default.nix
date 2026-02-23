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
        modi = "drun,emoji";
        display-emoji = "Emoji";
        hide-scrollbar = true;
      };

      theme = lib.mkForce ./cofi.rasi;
    };

    xdg.dataFile = {
      "rofi/themes/clauncher.rasi".text =
        # rasi
        ''
          @theme "cofi"

          inputbar {
            children: [ "textbox-search-icon","entry","num-filtered-rows","textbox-num-sep","num-rows","case-indicator" ];
          }

          entry {
            placeholder: "Search...";
            placeholder-color: @subtext0;
          }

          textbox-search-icon {
            margin: 0 0.25em 0 0 ;
            expand: false;

            str: " ";
            text-color: @subtext0;
          }

          listview {
            require-input: true;
            dynamic: true;
            fixed-height: false;
          }
        '';
    };

    catppuccin.rofi.enable = true;
  };
}
