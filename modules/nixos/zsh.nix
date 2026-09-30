{
  inputs,
  moduleWithSystem,
  ...
}: {
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

      environment.sessionVariables."BAT_THEME" = "Catppuccin Mocha";
      programs.bat = {
        enable = mkDefault true;
      };
      environment.shellAliases.cat = "bat -pp";
    };
  };

  perSystem = {
    pkgs,
    self',
    ...
  }: {
    packages.zsh = inputs.wrappers.wrappers.zsh.wrap {
      inherit pkgs;
      runtimePkgs = [
        pkgs.lsd
        pkgs.devenv
        pkgs.fzf
        pkgs.zoxide
        pkgs.eza
        self'.packages.oh-my-posh
      ];
      zshAliases = {
        blub = "echo 'hello from nix'";

        # git
        gst = "git status";
        gd = "git diff";
        ga = "git add";
        gc = "git commit";
        gp = "git push";
        gl = "git log";
        gco = "git checkout";

        # ls
        ls = "eza";
        ll = "eza -l";
        la = "eza -a";
        lt = "eza --tree";
        llt = "eza --tree -l";
        lla = "eza -la";
      };
      hmSessionVariables = null;
      zshrc.content =
        # sh
        ''
          setopt APPEND_HISTORY HIST_EXPIRE_DUPS_FIRST HIST_FCNTL_LOCK HIST_FIND_NO_DUPS HIST_IGNORE_DUPS HIST_IGNORE_SPACE SHARE_HISTORY

          # Setup command line history.
          # Don't export these, otherwise other shells (bash) will try to use same HISTFILE.
          SAVEHIST=100000
          HISTSIZE=100000
          HISTFILE=''${ZDOTDIR:-''${XDG_CONFIG_HOME:-$HOME/.config}/zsh}/.zsh_history

          # Enable autocompletion.
          autoload -U compinit && compinit

          # Fzf
          FZF_CTRL_T_COMMAND= FZF_ALT_C_COMMAND= source <(fzf --zsh)

          # Zoxide
          eval "$(zoxide init --cmd cd zsh)"

          # Oh My Posh
          function _update_sudo_cache() {
            sudo -Nnv &>/dev/null # detect whether credentials are valid
            export SUDO_CACHE=$(( ! $? ))
          }

          autoload -Uz add-zsh-hook
          add-zsh-hook precmd _update_sudo_cache
          eval "$(oh-my-posh init zsh)"

          # Syntax Highlighting
          source ${pkgs.zsh-fast-syntax-highlighting}/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh

          # Vi mode
          function zvm_config() {
            ZVM_VI_HIGHLIGHT_FOREGROUND=none
            ZVM_VI_HIGHLIGHT_BACKGROUND=none
            ZVM_VI_HIGHLIGHT_EXTRASTYLE=none
            ZVM_LINE_INIT_MODE=$ZVM_MODE_INSERT

            ZVM_INSERT_MODE_CURSOR=$ZVM_CURSOR_BLOCK

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
  };
}
