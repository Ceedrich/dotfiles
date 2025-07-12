{
  lib,
  config,
  ...
}: let
  zsh = config.programs.zsh;
  bash = config.programs.bash;

  inherit (lib) mkIf;
in {
  imports = [
    ./integrations
  ];
  config = {
    programs.zsh = mkIf zsh.enable {
      enableCompletion = true;
      autocd = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      historySubstringSearch.enable = true;
      dotDir = ".config/zsh";
      initContent =
        /*
        sh
        */
        ''
          bindkey -v
          setopt correct

          zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
          zstyle ':completion:*' menu select
        '';
    };

    programs.bash = mkIf bash.enable {
      enableCompletion = true;
    };
  };
}
