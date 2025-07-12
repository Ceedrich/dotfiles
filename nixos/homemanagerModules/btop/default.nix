{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.programs.btop;
in {
  config = lib.mkIf cfg.enable {
    programs.btop = {
      package = pkgs.btop.override {rocmSupport = true;};
      settings.vim_keys = true;
    };
  };
}
