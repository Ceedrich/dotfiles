{...}: {
  # home.sessionVariables = {
  #   TERMINAL = "ghostty";
  # };
  programs.ghostty = {
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
        "page_up=scroll_page_up"
        "page_down=scroll_page_down"
      ];
    };
  };
}
