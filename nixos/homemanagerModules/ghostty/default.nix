{ lib, config, ... }: {
  options = {
    ghostty.enable = lib.mkEnableOption "enable ghostty";
  };

  config = lib.mkIf config.ghostty.enable {
    home.sessionVariables = {
      TERMINAL = "ghostty";
    };
    programs.ghostty = {
      enable = true;
      clearDefaultKeybinds = true;
      settings = {
        font-family = "JetBrainsMono Nerd Font";
        font-size = 16;
        theme = "catppuccin-mocha";
        window-decoration = false;
        confirm-close-surface = false;
        title = "Ghostty";

        keybind = [
          "ctrl+shift+r=reload_config"
          "ctrl+shift+v=paste_from_clipboard"
          "ctrl+shift+c=copy_to_clipboard"
        ];
      };
    };
  };
}
