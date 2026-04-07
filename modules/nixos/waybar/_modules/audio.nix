{
  lib,
  pkgs,
  config,
  ...
}: let
  wb = config.programs.waybar;
  cfg = wb.modules.audio;
in {
  options.programs.waybar.modules.audio = {
    name = lib.mkOption {
      type = lib.types.str;
      default = "pulseaudio";
      readOnly = true;
    };
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
  config.programs.waybar = lib.mkIf cfg.enable {
    settings = let
      settings = lib.genAttrs cfg.bars (bar: {
        "${cfg.name}" = {
          format = "{volume}% {icon}";
          format-bluetooth = "{volume}% {icon}";
          format-muted = "{volume}% 󰝟";
          format-icons = {
            headphone = "󰋋";
            headset = "󰋎";
            default = ["󰕿" "󰖀" "󰕾"];
          };
          reverse-scrolling = true;
          on-click = "${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_SINK@ toggle";
          on-click-right = lib.getExe cfg.pavucontrolPackage;
        };
      });
    in
      settings;
    style =
      #css
      ''
        #${cfg.name}.muted {
          color: @overlay0;
        }
      '';
  };
}
