{
  ceedrichPkgs,
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.programs.hyprland;
in {
  imports = [
    ./hyprbars.nix
    ./swaync.nix
    ./screenshots.nix
  ];
  options.programs.hyprland = let
    types = lib.types;
  in {
    mainMod = lib.mkOption {
      type = types.str;
      default = "SUPER";
    };
    terminal = lib.mkOption {
      type = types.str;
      default = "${config.programs.ghostty.package}/bin/ghostty";
    };
    launcher = lib.mkOption {
      type = types.str;
      default = "rofi -show drun -show-icons";
    };
    autostart = lib.mkOption {
      type = types.listOf types.str;
      default = [];
    };
    powermenuPackage = lib.mkOption {
      type = types.package;
      default = let
        commands = config.logoutCommands;
      in
        ceedrichPkgs.power-menu.override {
          lockCommand = commands.lock;
          logoutCommand = commands.logout;
          shutdownCommand = commands.shutdown;
          rebootCommand = commands.reboot;
          suspendCommand = commands.suspend;
        };
    };
    extra-packages = lib.mkOption {
      type = types.listOf types.package;
      default = [];
    };
  };

  config = lib.mkIf cfg.enable {
    services.xserver.enable = true;
    services.displayManager.gdm.enable = true;

    environment.systemPackages = with pkgs;
      [
        networkmanagerapplet
        blueman
        libnotify
        nwg-drawer
        cfg.powermenuPackage
      ]
      ++ cfg.extra-packages;

    programs.hyprland = {
      xwayland.enable = true;
    };

    global-hm.config.wayland.windowManager.hyprland = {
      enable = true;
      systemd.enableXdgAutostart = true;
      plugins = with pkgs.hyprlandPlugins; [
        xtra-dispatchers
        hyprspace
      ];
      settings = let
        inherit
          (cfg)
          mainMod
          terminal
          launcher
          autostart
          powermenuPackage
          ;
      in {
        # plugin.overview = {
        #   showEmptyWorkspace = true;
        #   showNewWorkspace = false;
        # };

        exec-once = autostart;

        # Bindings
        bind = let
          wpctl = "${pkgs.wireplumber}/bin/wpctl";
          brightnessctl = "${pkgs.brightnessctl}/bin/brightnessctl";
        in
          [
            "${mainMod}, return, exec, ${terminal}"
            "${mainMod}, Q, killactive"
            "${mainMod} SHIFT, Q, exec, ${lib.getExe powermenuPackage}"

            "${mainMod}, T, togglefloating"
            "${mainMod}, F, fullscreen"

            "${mainMod}, Space, exec, ${launcher} -run-command '{cmd}'"

            "${mainMod}, P, exec, ${ceedrichPkgs.passmenu}/bin/passmenu"

            "${mainMod}, h, movefocus, l"
            "${mainMod}, l, movefocus, r"
            "${mainMod}, k, movefocus, u"
            "${mainMod}, j, movefocus, d"

            "${mainMod} SHIFT, h, movewindow, l"
            "${mainMod} SHIFT, l, movewindow, r"
            "${mainMod} SHIFT, k, movewindow, u"
            "${mainMod} SHIFT, j, movewindow, d"

            "${mainMod}, 1, workspace, 1"
            "${mainMod}, 2, workspace, 2"
            "${mainMod}, 3, workspace, 3"
            "${mainMod}, 4, workspace, 4"
            "${mainMod}, 5, workspace, 5"
            "${mainMod}, 6, workspace, 6"
            "${mainMod}, 7, workspace, 7"
            "${mainMod}, 8, workspace, 8"
            "${mainMod}, 9, workspace, 9"
            "${mainMod}, 0, workspace, 10"

            "${mainMod} SHIFT, 1, movetoworkspace, 1"
            "${mainMod} SHIFT, 2, movetoworkspace, 2"
            "${mainMod} SHIFT, 3, movetoworkspace, 3"
            "${mainMod} SHIFT, 4, movetoworkspace, 4"
            "${mainMod} SHIFT, 5, movetoworkspace, 5"
            "${mainMod} SHIFT, 6, movetoworkspace, 6"
            "${mainMod} SHIFT, 7, movetoworkspace, 7"
            "${mainMod} SHIFT, 8, movetoworkspace, 8"
            "${mainMod} SHIFT, 9, movetoworkspace, 9"
            "${mainMod} SHIFT, 0, movetoworkspace, 10"

            ", XF86AudioMute, exec, ${wpctl} set-mute @DEFAULT_AUDIO_SINK@ toggle"
            ", XF86AudioRaiseVolume, exec, ${wpctl} set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 10%+"
            ", XF86AudioLowerVolume, exec, ${wpctl} set-volume -l 0.0 @DEFAULT_AUDIO_SINK@ 10%-"
            ", XF86MonBrightnessDown, exec, ${brightnessctl} -q s 10%-"
            ", XF86MonBrightnessUp, exec, ${brightnessctl} -q s +10%"
          ]
          ++ lib.optional config.services.clipboard.enable "${mainMod}, V, exec, cliphist list | rofi -dmenu -i -p 'Clipboard' -display-columns 2 | cliphist decode | wl-copy";

        bindm = [
          "${mainMod}, mouse:272, resizewindow"
          "${mainMod}, mouse:273, movewindow"
        ];

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
          "3, up, dispatcher, exec, nwg-drawer -wm hyprland"
          "3, pinchin, dispatcher, plugin:xtd:bringallfrom, special:minimized"
          "3, pinchout, dispatcher, movetoworkspacesilent, special:minimized"
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
          "animation popin 90%, ^rofi$"
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
            "Import"
            "Choose File"
            "Rename"
            "This page wants to save"
          ];
        in
          [
            # Works from 0.53
            # "opacity 0.7 0.6, match:class com\.mitchellh\.ghostty"
            # "suppress_event maximize, match:class .*"

            # Up until 0.52
            "opacity 0.7 0.6, class:com\.mitchellh\.ghostty"
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
}
