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
      services.displayManager.gdm.enable = true;

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
          wayland.windowManager.hyprland = {
            enable = true;
            systemd.enableXdgAutostart = true;
            plugins = with pkgs.hyprlandPlugins; [
              xtra-dispatchers
            ];
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

              general = {
                resize_on_border = true;
              };

              gestures = {
                workspace_swipe_distance = 200;
              };

              gesture = [
                "3, up, dispatcher, exec, if pgrep rofi; then pkill rofi; else rofi -show drun -theme drawer; fi"
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
                "noanim, ^rofi$"
                "animation slide, ^cshell.*$"
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
                  # Works from 0.53
                  # "opacity 0.7 0.6, match:class foot"
                  # "suppress_event maximize, match:class .*"

                  # Up until 0.52
                  "opacity 0.7 0.6, class:foot"
                  "plugin:hyprbars:no_bar, class:foot"
                ]
                # Works from 0.53
                # ++ (builtins.map (regex: "float on, match:class ${regex}") floating);
                # Up until 0.52
                ++ [
                  "float, center, class:([Xx]dg-desktop-portal-[a-zA-z0-9]*)"
                ]
                ++ (builtins.map (regex: "float, title:^${regex}$") floatingTitle)
                ++ (builtins.map (regex: "float, class:${regex}") floatingClass);
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
