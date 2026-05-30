{...}: {
  flake.nixosModules.zsh = {
    config,
    lib,
    pkgs,
    ...
  }: let
    cfg = config.programs.zsh;
    inherit (lib) mkDefault;
  in {
    config = {
      programs.zsh = lib.mkIf cfg.enable {
        autosuggestions.enable = mkDefault true;

        shellInit =
          #zsh
          ''
            ZDOTDIR="''${XDG_CONFIG_HOME:-$HOME/.config}/zsh"
          '';

        histFile = "$ZDOTDIR/.zsh_history";
        histSize = 100000;

        setOptions = [
          "APPEND_HISTORY"
          "HIST_EXPIRE_DUPS_FIRST"
          "HIST_FCNTL_LOCK"
          "HIST_FIND_NO_DUPS"
          "HIST_IGNORE_DUPS"
          "HIST_IGNORE_SPACE"
          "SHARE_HISTORY"
        ];

        interactiveShellInit =
          # sh
          ''
            source ${pkgs.zsh-fast-syntax-highlighting}/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh

            function zvm_config() {
              ZVM_VI_HIGHLIGHT_FOREGROUND=none
              ZVM_VI_HIGHLIGHT_BACKGROUND=none
              ZVM_VI_HIGHLIGHT_EXTRASTYLE=none
              ZVM_LINE_INIT_MODE=$ZVM_MODE_INSERT

              local ncur=$(zvm_cursor_style $ZVM_NORMAL_MODE_CURSOR)

              # Append your custom color for your cursor
              ZVM_NORMAL_MODE_CURSOR=$ncur'\e\e]12;green\a'

              ZVM_INIT_MODE=sourcing
            }
            source ${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh

            bindkey -v
            setopt correct

            zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
            zstyle ':completion:*' menu select

            # pres ^a to insert date
            currentDate() {
              zle -U -- "$(date +'%Y%m%d_')"
            }
            zle -N currentDate
            bindkey '^A' currentDate

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

      programs.zoxide = {
        enable = mkDefault true;
        flags = ["--cmd cd"];
      };

      programs.bat = {
        enable = mkDefault true;
      };
      environment.shellAliases.cat = "bat -pp";
    };
  };
}
