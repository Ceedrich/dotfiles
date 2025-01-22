{ config, pkgs, inputs, ... }:

{
  imports = [
    ./modules/neovim.nix
    ./modules/tmux.nix
    ./modules/git.nix
    ./modules/shell.nix
  ];
  home.stateVersion = "24.11";

  home.username = "ceedrich";
  home.homeDirectory = "/home/ceedrich";

  home.packages = with pkgs; [
    ghostty
    delta
    fd
    rust-with-analyzer
    pnpm
    blesh
  ];

  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };

  programs.eza = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    icons = "auto";
  };
  home.shellAliases.ls = "eza";
  home.shellAliases.l = "eza --icons --git -lah";

  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    options = [ "--cmd" "cd" ];
  };
  programs.yazi = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };
  programs.bat =
    let
      catppuccin-theme = "${inputs.catppuccin-bat-repo}/themes/Catppuccin Mocha.tmTheme";
    in
    {
      enable = true;
      config.theme = "Catppuccin Mocha";
      themes."Catppuccin Mocha".src = catppuccin-theme;
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
