{
  pkgs,
  lib,
  config,
  selfpkgs,
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
      terminal = "${lib.getExe selfpkgs.terminal}";
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
        display-games = "Games";
        modi = "drun,emoji,window,nerdy,games";
        hide-scrollbar = true;
      };

      theme = ./cofi.rasi;
    };

    xdg.dataFile = let
      mkThemes = files:
        lib.pipe files [
          (lib.map (file: lib.nameValuePair "rofi/themes/${file}" {source = ./${file};}))
          lib.listToAttrs
        ];
    in
      mkThemes [
        "games.rasi"
        "fullscreen.rasi"
        "drawer.rasi"
      ]
      // {
        "rofi/themes/catppuccin-mocha.rasi".text = config.catppuccin.colorsRasi;
      };

    catppuccin.rofi.enable = false;
  };
}
