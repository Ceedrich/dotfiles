{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.programs.wlr-which-key;
in {
  options.programs.wlr-which-key = {
    enable = lib.mkEnableOption "wlr-which-key";
    package = lib.mkPackageOption pkgs "wlr-which-key" {};
  };
  config = {
    environment.systemPackages = [cfg.package];
    environment.etc."xdg/wlr-which-key/config.yaml".source = let
      yaml = pkgs.formats.yaml {};
      colors = config.catppuccin.colors;
    in
      yaml.generate "config.yaml" {
        background = colors.base.hex;
        color = colors.text.hex;
        border = colors.accent.hex;

        menu = [
          {
            key = "space";
            desc = "Search";
            cmd = "rofi -show drun -show-icons";
          }
          {
            key = "o";
            desc = "Open Documents";
            submenu = [
              {
                key = "p";
                desc = "PDF";
                cmd = "rofi-pdfmenu";
              }
            ];
          }
        ];
      };
  };
}
