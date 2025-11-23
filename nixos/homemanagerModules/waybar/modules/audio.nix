{
  lib,
  pkgs,
  config,
  ...
}: {
  options.programs.waybar.modules.audio = {
    enable = lib.mkOption {
      description = "enable audio module";
      default = true;
      type = lib.types.bool;
    };
    pavucontrolPackage = lib.mkPackageOption pkgs "pavucontrol" {};
  };
  config.programs.waybar = let
    cfg = config.programs.waybar.modules.audio;
  in {
    settings.mainBar = lib.mkIf cfg.enable {
      "pulseaudio" = {
        format = "{volume}% {icon}";
        format-bluetooth = "{volume}% {icon}";
        format-muted = "{volume}% 󰝟";
        format-icons.default = ["󰖀" "󰕾"];
        scroll-step = 3;
        on-click = "wpctl set-mute @DEFAULT_SINK@ toggle";
        on-click-right = lib.getExe cfg.pavucontrolPackage;
      };
    };
    style =
      #css
      ''
        #pulseaudio {
          border-bottom: 2px solid;
        }
        #pulseaudio.muted {
          color: @overlay0;
        }
      '';
  };
}
