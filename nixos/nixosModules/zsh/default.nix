{
  config,
  lib,
  ...
}: let
  cfg = config.programs.zsh;
  inherit (lib) mkDefault;
in {
  config = {
    programs.zsh = {
      syntaxHighlighting.enable = mkDefault true;
      autosuggestions.enable = mkDefault true;

      interactiveShellInit =
        # sh
        ''
          bindkey -v
          setopt correct

          zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
          zstyle ':completion:*' menu select
        '';
    };

    programs.starship = {
      enable = true;
    };
  };
}
