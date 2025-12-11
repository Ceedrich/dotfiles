{
  lib,
  config,
  pkgs,
  meta,
  inputs,
  ...
}: let
  cfg = config.programs.hyprland;
  hyprpkgs = inputs.hyprland.packages.${meta.system};
in {
  imports = [inputs.hyprland.nixosModules.default];

  options.programs.hyprland = let
    types = lib.types;
  in {
    mainMod = lib.mkOption {
      type = types.str;
      default = "SUPER";
    };
    terminal = lib.mkOption {
      type = types.str;
      default = "${pkgs.ghostty}/bin/ghostty";
    };
    launcher = lib.mkOption {
      type = types.str;
      default = "rofi -show drun -show-icons";
    };
    screenshot = lib.mkOption {
      type = types.str;
      default = "${pkgs.hyprshot}/bin/hyprshot -o ~/Pictures/Screenshots";
    };
    autostart = lib.mkOption {
      type = types.listOf types.str;
      default = [];
    };
    powermenu = lib.mkOption {
      type = types.str;
      default = let
        power-menu = pkgs.callPackage ../homemanagerModules/hyprland/rofi/power-menu.nix {
          logoutCommand = "hyprctl dispatch exit";
        };
      in "${lib.getExe power-menu}";
    };
    emoji-picker = lib.mkOption {
      type = types.str;
      default = "rofi/bin/rofi -modi emoji -show emoji";
    };
    extra-packages = lib.mkOption {
      type = types.listOf types.package;
      default = with pkgs; [
        networkmanagerapplet
        swaynotificationcenter
        blueman
        libnotify
      ];
    };
  };

  config = let
    passmenu = pkgs.callPackage ../packages/passmenu {};
  in
    lib.mkIf cfg.enable {
      services.xserver.enable = true;
      services.displayManager.gdm.enable = true;

      environment.systemPackages = cfg.extra-packages;

      programs.uwsm.enable = lib.mkDefault true;
      programs.hyprland = {
        withUWSM = lib.mkDefault true;
        package = hyprpkgs.hyprland;
        portalPackage = hyprpkgs.xdg-desktop-portal-hyprland;
        xwayland.enable = true;

        settings = let
          inherit
            (cfg)
            mainMod
            terminal
            launcher
            autostart
            screenshot
            powermenu
            emoji-picker
            ;

          uwsm-run = lib.optionalString cfg.withUWSM "uwsm app --";
        in {
          exec-once = autostart;

          # Bindings
          bind = [
            "${mainMod}, return, exec, ${uwsm-run} ${terminal}"
            "${mainMod}, Q, killactive"
            "${mainMod} SHIFT, Q, exec, ${uwsm-run} ${powermenu}"

            "${mainMod}, period, exec, ${emoji-picker}"
            "${mainMod}, T, togglefloating"
            "${mainMod}, F, fullscreen"

            "${mainMod}, Space, exec, ${launcher} -run-command '${uwsm-run} {cmd}'"
            ", PRINT, exec, ${uwsm-run} ${screenshot} -m region"
            "SHIFT, PRINT, exec, ${uwsm-run} ${screenshot} -m window"

            "${mainMod}, P, exec, ${uwsm-run} ${passmenu}/bin/passmenu"

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
          ];

          bindm = [
            "${mainMod}, mouse:272, movewindow"
            "${mainMod}, mouse:273, resizewindow"
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

          gestures = {
            workspace_swipe_distance = 200;
          };

          gesture = [
            "3, horizontal, workspace"
          ];

          # Animation
          animation = [
            "workspaces, 1, 2, default"
            "windows, 1, 0.5, default"
            "fade, 1, 0.5, default"
          ];

          misc = {
            force_default_wallpaper = false;
            disable_hyprland_logo = true;
          };

          windowrule = let
            floating = [
              "org.pulseaudio.pavucontrol"
              ".blueman-manager-wrapped"
            ];
          in
            [
              "opacity 0.7 0.6, match:class com\.mitchellh\.ghostty"
              "suppress_event maximize, match:class .*"
              # "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"
            ]
            ++ (builtins.map (regex: "float on, match:class ${regex}") floating);
        };
      };

      environment.sessionVariables = {
        WLR_NO_HARDWARE_CURSORS = "1";
        NIXOS_OZONE_WL = "1";
      };

      xdg.portal = {
        enable = true;
        wlr.enable = true;
        extraPortals = [pkgs.xdg-desktop-portal-gtk];
        configPackages = [hyprpkgs.xdg-desktop-portal-hyprland];
      };

      hardware = {
        graphics.enable = true;
      };
    };
}
