{
  config,
  lib,
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
    home.shellAliases = {
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
      "....." = "cd ../../../..";
    };
    programs.zsh = mkIf zsh.enable {
      enableCompletion = true;
      autocd = false;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      historySubstringSearch.enable = true;
      dotDir = "${config.xdg.configHome}/zsh";
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
