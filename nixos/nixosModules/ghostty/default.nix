{
  lib,
  config,
  ...
}: let
  cfg = config.programs.ghostty;
in {
  options.programs.ghostty = {
    enable = lib.mkEnableOption "enable ghostty";
  };
  config = lib.mkIf cfg.enable {
    global-hm.config.programs.ghostty = {
      enable = true;
      clearDefaultKeybinds = true;
      settings = {
        font-family = "JetBrainsMono Nerd Font";
        font-size = 14;
        theme = "catppuccin-mocha";
        window-decoration = false;
        working-directory = "home";
        confirm-close-surface = false;
        title = "Ghostty";
        bell-features = [
          "no-title"
        ];

        keybind = [
          "ctrl+shift+r=reload_config"
          "ctrl+shift+v=paste_from_clipboard"
          "ctrl+shift+c=copy_to_clipboard"

          "ctrl+shift+j=scroll_page_lines:3"
          "ctrl+shift+k=scroll_page_lines:-3"
          "page_up=scroll_page_up"
          "page_down=scroll_page_down"
        ];
      };
    };
  };
}
