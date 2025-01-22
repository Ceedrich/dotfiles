{ config, lib, ... }: {
  options = {
    zsh.enable = lib.mkEnableOption "enable zsh";
    bash.enable = lib.mkEnableOption "enable bash";
  };
  config = {
    programs.zsh = lib.mkIf config.zsh.enable {
      enable = true;
      enableCompletion = true;
      autocd = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      historySubstringSearch.enable = true;
      dotDir = ".config/zsh";
      initExtra = /* sh */ ''
        setopt correct

        zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}' 
        zstyle ':completion:*' menu select
      '';
    };
    programs.bash = lib.mkIf config.bash.enable {
      enable = true;
      enableCompletion = true;
    };

    programs.starship = {
      enable = true;
      enableZshIntegration = lib.mkIf config.zsh.enable true;
      enableBashIntegration = lib.mkIf config.bash.enable true;
    };

    # Defaults
    zsh.enable = lib.mkDefault true;
  };
}
