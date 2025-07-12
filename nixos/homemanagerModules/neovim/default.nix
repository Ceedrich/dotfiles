{
  lib,
  config,
  ...
}: let
  cfg = config.programs.neovim;
in {
  config = lib.mkIf cfg.enable {
    home.shellAliases = {
      v = "nvim";
    };
    programs.neovim = {
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
      defaultEditor = true;
    };
  };
}
