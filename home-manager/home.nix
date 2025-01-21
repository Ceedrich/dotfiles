{ config, pkgs, inputs, ... }:

{
  home.stateVersion = "24.11";

  home.username = "ceedrich";
  home.homeDirectory = "/home/ceedrich";

  home.packages = with pkgs; [
    ghostty
    tmux
    delta
    git
    fd
    rust-with-analyzer
    pnpm
  ];
  home.shellAliases = {
    # Git Aliases
    gst = "git status";
    gd = "git diff";
    ga = "git add";
    gc = "git commit";
    gp = "git push";
    gco = "git checkout";
  };

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

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autocd = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    dotDir = ".config/zsh";
    initExtra = /* sh */ ''
      setopt correct

      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}' 
      zstyle ':completion:*' menu select
    '';
  };
  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    options = [ "--cmd" "cd" ];
  };
  programs.starship.enable = true;
  programs.yazi = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };
  programs.bat = {
    enable = true;
    config.theme = "Catppuccin Mocha";
    themes."Catppuccin Mocha" = {
      src = "${inputs.catppuccin-bat-repo}/themes/Catppuccin Mocha.tmTheme";
    };
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
