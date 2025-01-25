{ config, lib, catppuccin, ... }: {
  options.shell.integrations = {
    starship.enable = lib.mkEnableOption "enable starship";
    fzf.enable = lib.mkEnableOption "enable fzf";
    eza.enable = lib.mkEnableOption "enable eza";
    zoxide.enable = lib.mkEnableOption "enable zoxide";
    bat.enable = lib.mkEnableOption "enable bat";
  };

  config =
    let
      shell = config.shell;
      integrations = shell.integrations;
    in
    {
      programs.fzf = lib.mkIf integrations.fzf.enable {
        enable = true;
        enableBashIntegration = lib.mkIf shell.bash.enable true;
        enableZshIntegration = lib.mkIf shell.zsh.enable true;
      };
      programs.eza = lib.mkIf integrations.eza.enable {
        enable = true;
        enableBashIntegration = lib.mkIf shell.bash.enable true;
        enableZshIntegration = lib.mkIf shell.zsh.enable true;
        icons = "auto";
      };
      home.shellAliases.ls = lib.mkIf integrations.eza.enable "eza";
      home.shellAliases.l = lib.mkIf integrations.eza.enable "eza --icons --git -lah";

      programs.zoxide = lib.mkIf integrations.zoxide.enable {
        enable = true;
        enableBashIntegration = lib.mkIf shell.bash.enable true;
        enableZshIntegration = lib.mkIf shell.zsh.enable true;
        options = [ "--cmd" "cd" ];
      };

      programs.bat =
        lib.mkIf integrations.bat.enable {
          enable = true;
          config.theme = "Catppuccin Mocha";
          themes."Catppuccin Mocha".src = catppuccin.bat;
        };

      # Defaults
      shell.integrations = {
        starship.enable = lib.mkDefault true;
        fzf.enable = lib.mkDefault true;
        eza.enable = lib.mkDefault true;
        zoxide.enable = lib.mkDefault true;
        bat.enable = lib.mkDefault true;
      };
    };
}
