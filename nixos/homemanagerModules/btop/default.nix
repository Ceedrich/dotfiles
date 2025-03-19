{ pkgs, lib, config, ... }: {
  options = {
    btop.enable = lib.mkEnableOption "enable btop";
  };
  config = lib.mkIf config.btop.enable {
    programs.btop = {
      package = (pkgs.btop.override { rocmSupport = true; });
      enable = true;
      settings.vim_keys = true;
    };
  };
}
