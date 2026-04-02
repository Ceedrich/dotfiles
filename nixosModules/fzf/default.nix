{
  config,
  lib,
  ...
}: let
  cfg = config.programs.fzf;
in
  lib.mkIf cfg.enable {
    programs.fzf = {
      fuzzyCompletion = lib.mkDefault true;
      # keybindings = mkDefault true; # customize this
    };

    programs.bash.interactiveShellInit = ''
      FZF_CTRL_R_COMMAND= FZF_ALT_C_COMMAND= eval "$(fzf --bash)"
    '';
    programs.zsh.interactiveShellInit = ''
      FZF_CTRL_R_COMMAND= FZF_ALT_C_COMMAND= source <(fzf --zsh)
    '';
  }
