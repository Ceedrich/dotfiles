{
  inputs,
  moduleWithSystem,
  config,
  lib,
  ...
}: {
  flake.nixosModules.wlr-which-key = moduleWithSystem ({self', ...}: {
    home-manager.sharedModules = [
      {
        home.packages = [self'.packages.wlr-which-key];
      }
    ];
  });

  perSystem = {
    pkgs,
    self',
    ...
  }: {
    packages.wlr-which-key = inputs.wrappers.wrappers.wlr-which-key.wrap {
      inherit pkgs;
      runtimePkgs = [self'.packages.rofi-file-picker];
      settings = {
        font = "JetBrainsMono Nerd Font 16";
        background = config.catppuccin.colors.base-90.hex;
        color = config.catppuccin.colors.text.hex;
        border = config.catppuccin.colors.accent.hex;
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
            cmd = "power-menu";
          }
          {
            key = "p";
            desc = "󰌾 Password Menu";
            cmd = "${lib.getExe self'.packages.passmenu}";
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
            key = "t";
            desc = "Toggle focus mode";
            cmd = "${lib.getExe self'.packages.hyprland-focus-mode} toggle";
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
  };
}
