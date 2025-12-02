{
  lib,
  config,
  ...
}: let
  cfg = config.programs.zsh.integrations;
in {
  options.programs.zsh.integrations = {
    enable = lib.mkEnableOption "enable all Integrations";
    starship = lib.mkEnableOption "enable starship";
    fzf = lib.mkEnableOption "enable fzf";
    eza = lib.mkEnableOption "enable eza";
    zoxide = lib.mkEnableOption "enable zoxide";
    bat = lib.mkEnableOption "enable bat";
  };
  config = let
    inherit (lib) mkIf mkDefault;
    zsh_enabled = config.programs.zsh.enable;
    bash_enabled = config.programs.bash.enable;
  in {
    programs.starship = mkIf cfg.starship {
      enable = mkDefault true;
      enableZshIntegration = mkIf zsh_enabled true;
      enableBashIntegration = mkIf bash_enabled true;
      settings = builtins.fromTOML (builtins.readFile ./starship.toml);
    };

    programs.fzf = lib.mkIf cfg.fzf {
      enable = mkDefault true;
      enableZshIntegration = mkIf zsh_enabled true;
      enableBashIntegration = mkIf bash_enabled true;
    };

    programs.eza = lib.mkIf cfg.eza {
      enable = mkDefault true;
      enableZshIntegration = mkIf zsh_enabled true;
      enableBashIntegration = mkIf bash_enabled true;
      icons = "auto";
    };
    home.shellAliases.ls = mkIf cfg.eza "eza";
    home.shellAliases.l = mkIf cfg.eza "eza --icons --git -lah";

    programs.zoxide = mkIf cfg.zoxide {
      enable = mkDefault true;
      enableZshIntegration = mkIf zsh_enabled true;
      enableBashIntegration = mkIf bash_enabled true;
      options = ["--cmd" "cd"];
    };

    programs.bat = mkIf cfg.bat {
      enable = mkDefault true;
    };
    home.shellAliases.cat = lib.mkIf cfg.bat "bat -pp";

    programs.zsh.integrations = mkIf cfg.enable {
      starship = mkDefault true;
      fzf = mkDefault true;
      eza = mkDefault true;
      zoxide = mkDefault true;
      bat = mkDefault true;
    };
  };
}
