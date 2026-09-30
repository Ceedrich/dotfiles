{
  inputs,
  moduleWithSystem,
  ...
}: {
  flake.nixosModules.zsh = moduleWithSystem ({self', ...}: {
    nixpkgs.overlays = [
      (final: prev: {
        zsh = self'.packages.zsh;
      })
    ];
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      enableBashCompletion = true;
      autosuggestions.enable = true;

      histSize = 100000;
      # histFile = "$ZDOTDIR/.zsh_history";

      # shellInit =
      #   #sh
      #   ''
      #     ZDOTDIR="''${XDG_CONFIG_HOME:-$HOME/.config}/zsh"
      #   '';
    };

    # environment.sessionVariables."BAT_THEME" = "Catppuccin Mocha";
    # programs.bat = {
    #   enable = mkDefault true;
    # };
    # environment.shellAliases.cat = "bat -pp";
  });

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

        ".." = "cd ..";
        "..." = "cd ../..";
        "...." = "cd ../../..";
        "....." = "cd ../../../..";
        v = "nvim";
        vimdiff = "nvim -d";

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

          # Fzf
          FZF_CTRL_T_COMMAND= FZF_ALT_C_COMMAND= source <(fzf --zsh)

          # Zoxide
          eval "$(zoxide init --cmd cd zsh)"

          # Devenv
          eval "$(devenv hook zsh)"

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
