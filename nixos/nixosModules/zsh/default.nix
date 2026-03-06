{
  config,
  lib,
  ...
}: let
  cfg = config.programs.zsh;
  inherit (lib) mkDefault;
in {
  imports = [];
  config = {
    programs.zsh = lib.mkIf cfg.enable {
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

    environment.shellAliases = {
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
      "....." = "cd ../../../..";
      ga = "git add";
      gc = "git commit";
      gco = "git checkout";
      gd = "git diff";
      gp = "git push";
      gst = "git status";
      v = "nvim";
      vimdiff = "nvim -d";
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

    programs.eza.enable = mkDefault true;

    programs.zoxide = {
      enable = mkDefault true;
      flags = ["--cmd cd"];
    };

    programs.bat = {
      enable = mkDefault true;
    };
    environment.shellAliases.cat = "bat -pp";
  };
}
