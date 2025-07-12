{
  config,
  lib,
  ...
}: let
  programs = config.programs;
  cfg = programs.yazi;
in {
  config = lib.mkIf cfg.enable {
    programs.yazi = {
      enableBashIntegration = lib.mkIf programs.bash.enable true;
      enableZshIntegration = lib.mkIf programs.zsh.enable true;
    };
  };
}
