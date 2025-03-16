{ config, lib, ... }: {
  options = {
    yazi.enable = lib.mkEnableOption "enable yazi";
  };
  config = lib.mkIf config.yazi.enable {
    programs.yazi = {
      enable = true;
      enableBashIntegration = lib.mkIf config.bash.enable true;
      enableZshIntegration = lib.mkIf config.zsh.enable true;
    };
  };
}
