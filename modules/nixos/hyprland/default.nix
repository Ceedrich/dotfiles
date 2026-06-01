{inputs, ...}: {
  flake.nixosModules.hyprland = {
    config,
    lib,
    pkgs,
    ...
  }: let
    cfg = config.programs.hyprland;
  in {
    imports = [
      (inputs.import-tree ./_modules)
    ];
    options.programs.hyprland = let
      types = lib.types;
    in {
      mainMod = lib.mkOption {
        type = types.str;
        default = "SUPER";
      };
      autostart = lib.mkOption {
        type = types.listOf types.str;
        default = [];
      };
      extra-packages = lib.mkOption {
        type = types.listOf types.package;
        default = [];
      };
    };

    config = lib.mkIf cfg.enable {
      services.xserver.enable = true;
      services.xserver.excludePackages = [pkgs.xterm];
      services.displayManager.ly.enable = true;

      environment.systemPackages = with pkgs;
        [
          networkmanagerapplet
          blueman
          libnotify
          hyprshutdown
        ]
        ++ cfg.extra-packages;

      programs.hyprland = {
        xwayland.enable = true;
      };

      logoutCommands = {
        shutdown = ''hyprctl dispatch exec "hyprshutdown -t 'Shutting down...' --post-cmd 'systemctl poweroff'"'';
        reboot = ''hyprctl dispatch exec "hyprshutdown -t 'Restarting...' --post-cmd 'reboot'"'';
        logout = ''hyprctl dispatch exec "hyprshutdown -t 'Logging out...'"'';
      };

      nix.settings = {
        substituters = ["https://hyprland.cachix.org"];
        trusted-substituters = ["https://hyprland.cachix.org"];
        trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
      };

      home-manager.sharedModules = [
        {
          catppuccin.hyprland.enable = false;
          wayland.windowManager.hyprland = {
            extraConfig = ''
              $rosewater = rgb(f5e0dc)
              $rosewaterAlpha = f5e0dc

              $flamingo = rgb(f2cdcd)
              $flamingoAlpha = f2cdcd

              $pink = rgb(f5c2e7)
              $pinkAlpha = f5c2e7

              $mauve = rgb(cba6f7)
              $mauveAlpha = cba6f7

              $red = rgb(f38ba8)
              $redAlpha = f38ba8

              $maroon = rgb(eba0ac)
              $maroonAlpha = eba0ac

              $peach = rgb(fab387)
              $peachAlpha = fab387

              $yellow = rgb(f9e2af)
              $yellowAlpha = f9e2af

              $green = rgb(a6e3a1)
              $greenAlpha = a6e3a1

              $teal = rgb(94e2d5)
              $tealAlpha = 94e2d5

              $sky = rgb(89dceb)
              $skyAlpha = 89dceb

              $sapphire = rgb(74c7ec)
              $sapphireAlpha = 74c7ec

              $blue = rgb(89b4fa)
              $blueAlpha = 89b4fa

              $lavender = rgb(b4befe)
              $lavenderAlpha = b4befe

              $text = rgb(cdd6f4)
              $textAlpha = cdd6f4

              $subtext1 = rgb(bac2de)
              $subtext1Alpha = bac2de

              $subtext0 = rgb(a6adc8)
              $subtext0Alpha = a6adc8

              $overlay2 = rgb(9399b2)
              $overlay2Alpha = 9399b2

              $overlay1 = rgb(7f849c)
              $overlay1Alpha = 7f849c

              $overlay0 = rgb(6c7086)
              $overlay0Alpha = 6c7086

              $surface2 = rgb(585b70)
              $surface2Alpha = 585b70

              $surface1 = rgb(45475a)
              $surface1Alpha = 45475a

              $surface0 = rgb(313244)
              $surface0Alpha = 313244

              $base = rgb(1e1e2e)
              $baseAlpha = 1e1e2e

              $mantle = rgb(181825)
              $mantleAlpha = 181825

              $crust = rgb(11111b)
              $crustAlpha = 11111b
            '';
            enable = true;
            systemd.enableXdgAutostart = true;
            # plugins = with pkgs.hyprlandPlugins; [
            #   xtra-dispatchers
            # ];
            settings = let
              inherit (cfg) autostart;
            in {
              exec-once = autostart;

              # Input
              input = {
                kb_layout = "us";
                kb_variant = "altgr-intl";
                follow_mouse = 1;
                touchpad = {
                  scroll_factor = 0.2;
                  natural_scroll = true;
                };
              };

              dwindle.preserve_split = true;

              general = {
                resize_on_border = true;
                border_size = 2;
              };

              gestures = {
                workspace_swipe_distance = 200;
              };

              gesture = [
                "3, up, dispatcher, exec, cshell ipc call overview toggle"
                "3, horizontal, workspace"
              ];

              # Animation
              animation = [
                "workspaces, 1, 2, default"
                "windows, 1, 1, default, popin 90%"
                "fade, 1, 0.5, default"
              ];

              decoration = {
                rounding = 8;
                dim_special = 0.6;
              };

              misc = {
                force_default_wallpaper = false;
                disable_hyprland_logo = true;
              };

              layerrule = [
                "no_anim on, match:namespace ^rofi$"
                "animation slide, match:namespace ^cshell.*$"
              ];
              windowrule = let
                floatingClass = [
                  "org.pulseaudio.pavucontrol"
                  ".blueman-manager-wrapped"
                  "nm-connection-editor"
                ];
                floatingTitle = [
                  "Open File"
                  "Open"
                  "Save"
                  "Save File"
                  "Save As"
                  "Export"
                  "Picture-in-Picture"
                  "Import"
                  "Choose File"
                  "Rename"
                  "This page wants to save"
                ];
              in
                [
                  "match:class foot, opacity 0.7 0.6"
                  "match:class .*, suppress_event maximize"
                  "match:class [Xx]dg-desktop-portal-[a-zA-z0-9]*, float on, center on"
                ]
                ++ (builtins.map (regex: "float on, match:title ^${regex}$") floatingTitle)
                ++ (builtins.map (regex: "float on, match:class ${regex}") floatingClass);
            };
          };
        }
      ];

      environment.sessionVariables = {
        WLR_NO_HARDWARE_CURSORS = "1";
        NIXOS_OZONE_WL = "1";
      };

      xdg.portal = {
        enable = true;
        wlr.enable = true;
        extraPortals = [
          pkgs.xdg-desktop-portal-gtk
          pkgs.xdg-desktop-portal-wlr
          pkgs.xdg-desktop-portal-gnome
        ];
        configPackages = [pkgs.xdg-desktop-portal-hyprland];
      };

      hardware = {
        graphics.enable = true;
      };
    };
  };
}
