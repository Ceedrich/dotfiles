{...}: {
  flake.nixosModules.fzf = {
    lib,
    pkgs,
    ...
  }: {
    config = {
      programs.fzf = {
        fuzzyCompletion = lib.mkDefault true;
        # keybindings = mkDefault true; # customize this
      };

      environment.systemPackages = [pkgs.fzf];

      programs.bash.interactiveShellInit = ''
        FZF_CTRL_T_COMMAND= FZF_ALT_C_COMMAND= eval "$(fzf --bash)"
      '';
      programs.zsh.interactiveShellInit = ''
        FZF_CTRL_T_COMMAND= FZF_ALT_C_COMMAND= source <(fzf --zsh)
      '';
    };
  };
}
