{ config, lib, pkgs, ... }: {
  imports = [ ./integrations ];

  options.shell = {
    zsh.enable = lib.mkEnableOption "enable zsh";
    bash.enable = lib.mkEnableOption "enable bash";
  };
  config =
    let
      shell = config.shell;
    in
    {
      home.packages = with pkgs;[ 
        lib.mkif shell.bash.enable blesh 
      ];
      programs.zsh = lib.mkIf shell.zsh.enable {
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
      programs.bash = lib.mkIf shell.bash.enable {
        enable = true;
        enableCompletion = true;
      };

      programs.starship = {
        enable = true;
        enableZshIntegration = lib.mkIf shell.zsh.enable true;
        enableBashIntegration = lib.mkIf shell.bash.enable true;
        settings = builtins.fromTOML (builtins.readFile ./shell/starship.toml);
      };

      home.shellAliases = {
        "..." = "../..";
        "...." = "../../..";
        "....." = "../../../..";
      };

      # Defaults
      shell.zsh.enable = lib.mkDefault true;
    };
}
