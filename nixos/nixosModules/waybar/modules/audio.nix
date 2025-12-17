{
  lib,
  pkgs,
  config,
  ...
}: let
  wb = config.services.waybar;
  cfg = wb.modules.audio;
in {
  options.services.waybar.modules.audio = {
    enable = lib.mkOption {
      description = "enable audio module";
      default = true;
      type = lib.types.bool;
    };
    bars = lib.mkOption {
      default = [wb.mainBar];
      type = lib.types.listOf lib.types.str;
      description = "The names of the bars to add the module to";
    };
    pavucontrolPackage = lib.mkPackageOption pkgs "pavucontrol" {};
  };
  config.services.waybar = lib.mkIf cfg.enable {
    settings = let
      settings = lib.genAttrs cfg.bars (bar: {
        "pulseaudio" = {
          format = "{volume}% {icon}";
          format-bluetooth = "{volume}% {icon}";
          format-muted = "{volume}% 󰝟";
          format-icons.default = ["󰖀" "󰕾"];
          scroll-step = 3;
          on-click = "${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_SINK@ toggle";
          on-click-right = lib.getExe cfg.pavucontrolPackage;
        };
      });
    in
      settings;
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
