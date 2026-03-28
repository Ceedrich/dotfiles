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

      shellInit =
        # sh
        ''
          bindkey -v
          setopt correct

          zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
          zstyle ':completion:*' menu select

          function zle-keymap-select {
            if [[ $KEYMAP == vicmd ]] ||
              [[ $1 = 'block' ]]; then
              echo -ne '\e[1 q'
            elif [[ $KEYMAP == main ]] ||
              [[ $KEYMAP == viins ]] ||
              [[ $KEYMAP = "" ]] ||
              [[ $1 = 'beam' ]]; then
              echo -ne '\e[5 qd'
            fi
          }
          zle -N zle-keymap-select
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
      interactiveOnly = true;
      settings =
        lib.importTOML ./starship.toml
        // rec {
          palette = "catppuccin_${config.catppuccin.flavor}";
          palettes.${palette} = lib.mapAttrs (n: clr: clr.hex) config.catppuccin.colors;
        };
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
