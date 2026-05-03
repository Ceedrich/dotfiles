{inputs, ...}: {
  flake.nixosModules.wlr-which-key = {
    home-manager.sharedModules = [
      ({
        lib,
        pkgs,
        selfpkgs,
        config,
        ...
      }: let
      in {
        home.packages = [selfpkgs.wlr-which-key];
        xdg.configFile."wlr-which-key/config.yaml".source = let
          yamlFormat = pkgs.formats.yaml {};
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
                key = "t";
                desc = "Toggle focus mode";
                cmd = "${lib.getExe selfpkgs.hyprland-focus-mode} toggle";
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
        in
          yamlFormat.generate "config.yaml" settings;
      })
    ];
  };

  perSystem = {
    pkgs,
    self',
    ...
  }: {
    packages.wlr-which-key =
      (inputs.wrappers.lib.wrapModule {
        inherit pkgs;
        package = pkgs.wlr-which-key;
        extraPackages = [self'.packages.rofi-file-picker];
      }).wrapper;
  };
}
