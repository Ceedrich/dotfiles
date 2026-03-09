{
  config,
  lib,
  pkgs,
  ceedrichPkgs,
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
    global-hm.config.xdg.configFile."wlr-which-key/config.yaml".source = let
      yaml = pkgs.formats.yaml {};
      colors = config.catppuccin.colors;
    in
      yaml.generate "config.yaml" {
        font = "JetBrainsMono Nerd Font 16";
        background = colors.base.hex;
        color = colors.text.hex;
        border = colors.accent.hex;
        anchor = "top";
        margin_top = 200;
        inhibit_compositor_keyboard_shortcuts = true;

        menu = [
          {
            key = "space";
            desc = "Search";
            cmd = "rofi -show drun -show-icons";
          }
          {
            key = "q";
            desc = "Power Menu";
            cmd = "notify-send 'wlr-which-key' 'not yet implemented'";
          }
          {
            key = "p";
            desc = "Password Menu";
            cmd = "${lib.getExe ceedrichPkgs.passmenu}";
          }
          {
            key = "w";
            desc = "Windows";
            cmd = "rofi -modes window -show window";
          }
          {
            key = "e";
            desc = "Emojis";
            cmd = "rofi -show emoji";
          }
          {
            key = "c";
            desc = "Clipboard history";
            cmd = "cliphist list | rofi -dmenu -i -p 'Clipboard' -display-columns 2 | cliphist decode | wl-copy";
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
