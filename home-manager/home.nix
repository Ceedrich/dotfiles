{ pkgs, ... }:

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
    ghostty
    delta
    fd
    ripgrep
    rust-with-analyzer
    pnpm
    gcc
  ];

  programs.yazi = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = { };

  home.sessionVariables = {
    EDITOR = "nvim";
    TERMINAL = "ghostty";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
