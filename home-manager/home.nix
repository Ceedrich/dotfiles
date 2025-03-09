{ pkgs, lib, ... }:

{
  imports = [
    ./modules/neovim
    ./modules/tmux
    ./modules/git
    ./modules/shell
  ];
  home.stateVersion = "24.11";

  home.username = "ceedrich";
  home.homeDirectory = "/home/ceedrich";

  home.shellAliases = {
    "dev" = "nix develop -c zsh";
  };

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "spotify"
    ];

  gtk.enable = true;

  catppuccin = {
    enable = true;
    flavor = "mocha";
    zsh-syntax-highlighting.enable = false;
    gtk = {
      enable = true;
      gnomeShellTheme = true;
    };
  };

  home.packages = with pkgs; [
    delta
    jq
    fd
    ripgrep
    rust-with-analyzer
    pnpm
    gcc
    gnome-mines
    spotify
    gimp
    inkscape
    signal-desktop
  ];

  programs.btop = {
    enable = true;
    settings.vim_keys = true;
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

  programs.yazi = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    TERMINAL = "ghostty";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
