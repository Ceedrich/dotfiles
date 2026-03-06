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
      enable = mkDefault true;
      interactiveOnly = true;
      settings = builtins.fromTOML (builtins.readFile ./starship.toml);
    };

    programs.fzf = {
      keybindings = mkDefault true;
      fuzzyCompletion = mkDefault true;
    };

    # TODO: eza

    programs.zoxide = {
      enable = mkDefault true;
      flags = ["--no-cmd" "--cmd cd"];
    };

    programs.bat = {
      enable = mkDefault true;
    };
    environment.shellAliases.cat = "bat -pp";
  };
}
