{ pkgs
, lib
, config
, ...
}:

{
  options = {
    hyprland.enable = lib.mkEnableOption "enable hyprland";
  };
  config = lib.mkIf config.hyprland.enable {
    wayland.windowManager.hyprland = {
      enable = true;
      settings =
        let
          join = lib.strings.concatStringsSep;

          # TODO: those are defined elsewhere and thus dependent on other stuff
          terminal = "${pkgs.ghostty}/bin/ghostty";
          waybar = "${pkgs.waybar}/bin/waybar";
          powermenu =
            lib.getExe (import ./rofi/power-menu.nix { inherit pkgs lib; logoutCommand = "hyprctl dispatch exit"; });
          menu = "rofi -show drun -show-icons";
          emoji-picker = "rofi -modi emoji -show emoji";

          swaync = "${pkgs.swaynotificationcenter}/bin/swaync";
          nm-applet = "${pkgs.networkmanagerapplet}/bin/nm-applet";
          hyprshot = "${pkgs.hyprshot}/bin/hyprshot";
        in
        {
          # Global Variables
          "$screenshot" = "${hyprshot} -o ~/Pictures/Screenshots";

          # Autostart
          exec-once = "${waybar} & ${swaync} & ${nm-applet} --indicator &";

          # Input
          input = {
            kb_layout = "ch";
            follow_mouse = 1;
            touchpad.natural_scroll = false;
          };

          animation = [
            "workspaces, 1, 2, default"
            "windows, 1, 0.5, default"
            "fade, 1, 0.5, default"
          ];

          "$mainMod" = "SUPER";
          bind = [
            "$mainMod, return, exec, ${terminal}"
            "$mainMod, Q, killactive,"
            "$mainMod SHIFT, Q, exec, ${powermenu}"
            "$mainMod, period, exec, ${emoji-picker}"
            "$mainMod, T, togglefloating"
            "$mainMod, F, fullscreen"

            "$mainMod, D, exec, ${menu}"
            ", PRINT, exec, $screenshot -m region"
            "SHIFT, PRINT, exec, $screenshot -m window"

            "$mainMod, h, movefocus, l"
            "$mainMod, l, movefocus, r"
            "$mainMod, k, movefocus, u"
            "$mainMod, j, movefocus, d"

            "$mainMod SHIFT, h, movewindow, l"
            "$mainMod SHIFT, l, movewindow, r"
            "$mainMod SHIFT, k, movewindow, u"
            "$mainMod SHIFT, j, movewindow, d"

            "$mainMod, 1, workspace, 1"
            "$mainMod, 2, workspace, 2"
            "$mainMod, 3, workspace, 3"
            "$mainMod, 4, workspace, 4"
            "$mainMod, 5, workspace, 5"
            "$mainMod, 6, workspace, 6"
            "$mainMod, 7, workspace, 7"
            "$mainMod, 8, workspace, 8"
            "$mainMod, 9, workspace, 9"
            "$mainMod, 0, workspace, 10"

            "$mainMod SHIFT, 1, movetoworkspace, 1"
            "$mainMod SHIFT, 2, movetoworkspace, 2"
            "$mainMod SHIFT, 3, movetoworkspace, 3"
            "$mainMod SHIFT, 4, movetoworkspace, 4"
            "$mainMod SHIFT, 5, movetoworkspace, 5"
            "$mainMod SHIFT, 6, movetoworkspace, 6"
            "$mainMod SHIFT, 7, movetoworkspace, 7"
            "$mainMod SHIFT, 8, movetoworkspace, 8"
            "$mainMod SHIFT, 9, movetoworkspace, 9"
            "$mainMod SHIFT, 0, movetoworkspace, 10"
          ];
          # Mouse bindings
          bindm = [
            "$mainMod, mouse:272, movewindow"
            "$mainMod, mouse:273, resizewindow"
          ];
          misc = {
            force_default_wallpaper = 0;
            disable_hyprland_logo = true;
          };
          # No idea, the docs said it is good
          windowrulev2 =
            let
              floating = [ "pavucontrol" ];
            in
            [
              "opacity 0.9 0.8, class:^com\\.mitchellh\\.ghostty"
              "suppressevent maximize, class:.*"
              "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"
              "float, class:(${join "|" floating })"
            ];
        };
    };
  };
}
