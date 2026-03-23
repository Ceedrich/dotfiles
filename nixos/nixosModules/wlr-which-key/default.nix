{
  config,
  lib,
  pkgs,
  selfpkgs,
  ...
}: let
  cfg = config.programs.wlr-which-key;
in {
  options.programs.wlr-which-key = {
    enable = lib.mkEnableOption "wlr-which-key";
    package = lib.mkPackageOption pkgs "wlr-which-key" {};
  };
  config = {
    environment.systemPackages = [cfg.package selfpkgs.rofi-file-picker];
    global-hm.config.xdg.configFile."wlr-which-key/config.yaml".source = let
      yaml = pkgs.formats.yaml {};
      colors = config.catppuccin.colors;
    in
      yaml.generate "config.yaml" {
        font = "JetBrainsMono Nerd Font 16";
        background = colors.base-90.hex;
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
            desc = "󰐥 Power Menu";
            cmd = "${lib.getExe config.programs.power-menu.package}";
          }
          {
            key = "p";
            desc = "󰌾 Password Menu";
            cmd = "${lib.getExe selfpkgs.passmenu}";
          }
          {
            key = "w";
            desc = "󱂬 Windows";
            cmd = "rofi -modes window -show window";
          }
          {
            key = "c";
            desc = "󱉧 Clipboard history";
            cmd = "cliphist list | rofi -dmenu -i -p 'Clipboard' -display-columns 2 | cliphist decode | wl-copy";
          }
          {
            key = "e";
            desc = " Emojis";
            cmd = "rofi -show emoji";
          }
          {
            key = "i";
            desc = " Icons";
            cmd = "rofi -show nerdy";
          }
          {
            key = "g";
            desc = "󰊖 Games";
            cmd = "rofi -show games -theme games";
          }
          {
            key = "o";
            desc = "󰈔 Open Files";
            submenu = [
              {
                key = "p";
                desc = "󰈙 PDF";
                cmd = "rofi-file-picker -e pdf -p 'Open PDF'";
              }
              {
                key = "i";
                desc = "󰋩 Images";
                cmd = "rofi-file-picker -i -p 'Open Image'";
              }
              {
                key = "f";
                desc = "󰉋 Folders";
                cmd = "rofi-file-picker -f -p 'Open Folders'";
              }
              {
                key = "v";
                desc = "󰕧 Videos";
                cmd = "rofi-file-picker -v -p 'Open Videos'";
              }
            ];
          }
        ];
      };
  };
}
