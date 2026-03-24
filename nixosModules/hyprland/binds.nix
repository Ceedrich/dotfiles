{
  config,
  lib,
  selfpkgs,
  pkgs,
  ...
}: let
  cfg = config.programs.hyprland;
  inherit (cfg) mainMod;
in {
  config.home-manager.sharedModules = lib.mkIf cfg.enable [
    {
      wayland.windowManager.hyprland.settings = {
        bindm = [
          "${mainMod}, mouse:272, movewindow"
          "${mainMod}, mouse:273, resizewindow"
        ];

        bind =
          [
            # Main binds
            "${mainMod}, Q, killactive"
            "${mainMod}, T, togglefloating"
            "${mainMod}, F, fullscreen"

            # Launchers
            "${mainMod}, return, exec, ${lib.getExe selfpkgs.terminal}"
            "${mainMod}, Space, exec, ${lib.getExe selfpkgs.launcher}"

            # Window binds
            "${mainMod}, h, movefocus, l"
            "${mainMod}, l, movefocus, r"
            "${mainMod}, k, movefocus, u"
            "${mainMod}, j, movefocus, d"

            "${mainMod} SHIFT, h, movewindow, l"
            "${mainMod} SHIFT, l, movewindow, r"
            "${mainMod} SHIFT, k, movewindow, u"
            "${mainMod} SHIFT, j, movewindow, d"
          ]
          # Special buttons
          ++ (let
            wpctl = "${lib.getExe' pkgs.wireplumber "wpctl"}";
            brightnessctl = "${lib.getExe pkgs.brightnessctl}";
          in [
            ", XF86AudioMute, exec, ${wpctl} set-mute @DEFAULT_AUDIO_SINK@ toggle"
            ", XF86AudioRaiseVolume, exec, ${wpctl} set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 10%+"
            ", XF86AudioLowerVolume, exec, ${wpctl} set-volume -l 0.0 @DEFAULT_AUDIO_SINK@ 10%-"
            ", XF86MonBrightnessDown, exec, ${brightnessctl} -q s 10%-"
            ", XF86MonBrightnessUp, exec, ${brightnessctl} -q s +10%"
          ])
          # Workspaces
          ++ (lib.pipe (lib.genList (i: {
              key = toString (lib.mod (i + 1) 10);
              ws = toString (i + 1);
            })
            10) [
            (lib.map ({
              key,
              ws,
            }: [
              "${mainMod}, ${key}, workspace, ${ws}"
              "${mainMod} SHIFT, ${key}, movetoworkspace, ${ws}"
            ]))
            lib.flatten
          ]);
      };
    }
  ];
}
