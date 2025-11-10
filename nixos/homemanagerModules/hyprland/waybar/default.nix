{
  pkgs,
  lib,
  config,
  ...
}: {
  options.programs.waybar.modules = {
    audio = lib.mkEnableOption "enable audio module";
    clock = lib.mkEnableOption "enable clock module";
    date = lib.mkEnableOption "enable date module";
    tray = lib.mkEnableOption "enable tray module";
    powermenu = lib.mkEnableOption "enable powermenu";
    battery = lib.mkEnableOption "enable battery";
    player = lib.mkEnableOption "enable music player";
  };
  config = let
    inherit (lib) mkIf;
    wb = config.programs.waybar;
    m = wb.modules;

    clock = pkgs.callPackage ./modules/clock.nix {};
    player = pkgs.callPackage ./modules/player.nix {};
    battery = pkgs.callPackage ./modules/battery.nix {};
    powermenu = pkgs.callPackage ./modules/powermenu.nix {};

    modules = [clock player battery powermenu];

    moduleConfig = {
      style = (lib.readFile ./style.css) + (lib.strings.concatStrings (builtins.map (m: m.style) modules));
      settings = lib.foldl' lib.recursiveUpdate {} (builtins.map (m: m.settings) modules);
    };

    wb-config = {
      modules = {
        audio = lib.mkDefault true;
        clock = lib.mkDefault true;
        date = lib.mkDefault true;
        tray = lib.mkDefault true;
        powermenu = lib.mkDefault true;
        battery = lib.mkDefault true;
        player = lib.mkDefault true;
      };
      settings.mainBar = {
        position = "top";
        modules-left = [
          (mkIf m.date "clock#date")
          "hyprland/window"
        ];
        modules-center = [
          (mkIf m.player player.name)
        ];
        modules-right = [
          "hyprland/workspaces"
          (mkIf m.audio "pulseaudio")
          (mkIf m.battery battery.name)
          (mkIf m.clock clock.name)
          (mkIf m.powermenu powermenu.name)
          (mkIf m.tray "tray")
        ];

        pulseaudio = mkIf m.audio {
          format = "{volume}% {icon}";
          format-bluetooth = "{volume}% {icon}";
          format-muted = "{volume}% 󰝟";
          format-icons.default = ["󰖀" "󰕾"];
          scroll-step = 3;
          on-click = "wpctl set-mute @DEFAULT_SINK@ toggle";
          on-click-right = lib.getExe (pkgs.pavucontrol);
        };
        "clock#date" = mkIf m.date {
          format = "{:%d.%m.}";
          tooltip = false;
        };

        tray = mkIf m.tray {
          icon-size = 21;
          spacing = 10;
        };
      };
    };
  in {
    programs.waybar =mkIf wb.enable (moduleConfig // wb-config);
  };
}
