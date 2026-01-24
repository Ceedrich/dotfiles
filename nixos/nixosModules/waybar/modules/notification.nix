{
  pkgs,
  lib,
  config,
  ...
}: let
  wb = config.services.waybar;
  cfg = wb.modules.notification;
in {
  options.services.waybar.modules.notification = {
    enable = lib.mkOption {
      description = "notification";
      default = true;
      type = lib.types.bool;
    };
    swayncPackage = lib.mkPackageOption pkgs "swaynotificationcenter" {};
    bars = lib.mkOption {
      default = [wb.mainBar];
      type = lib.types.listOf lib.types.str;
      description = "The names of the bars to add the module to";
    };
  };
  config.services.waybar = let
    swaync-client = "${cfg.swayncPackage}/bin/swaync-client";
  in {
    settings = lib.genAttrs cfg.bars (bar: {
      "custom/notification" = {
        tooltip = true;
        format = "󱗼";
        format-icons = {
          # notification = "󱅫";
          # none = "󰂜";
          # dnd-notification = "󰂠";
          # dnd-none = "󰪓";
          # inhibited-notification = "󰂛";
          # inhibited-none = "󰪑";
          # dnd-inhibited-notification = "󰂛";
          # dnd-inhibited-none = "󰪑";
        };
        return-type = "json";
        exec = "${swaync-client} -swb";
        on-click = "${swaync-client} -t -sw";
        on-click-right = "${swaync-client} -d -sw";
        escape = true;
      };
    });
  };
}
