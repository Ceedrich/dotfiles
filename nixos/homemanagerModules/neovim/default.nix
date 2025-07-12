{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    neovim.enable = lib.mkEnableOption "enable neovim";
  };
  config = lib.mkIf config.neovim.enable {
    home.shellAliases = {
      v = "nvim";
      vi = "nvim";
      vim = "nvim";
      vimdiff = "nvim";
    };
    home.packages = with pkgs; [ceedrichVim];
  };
}
