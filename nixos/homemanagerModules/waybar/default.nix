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
    idle_inhibitor = lib.mkEnableOption "enable idle inhibitor";
  };
  config = let
    inherit (lib) mkIf;
    wb = config.programs.waybar;
    m = wb.modules;

    workspaces = pkgs.callPackage ./modules/workspaces.nix {};
    date = pkgs.callPackage ./modules/date.nix {};
    tray = pkgs.callPackage ./modules/tray.nix {};
    audio = pkgs.callPackage ./modules/audio.nix {};
    clock = pkgs.callPackage ./modules/clock.nix {};
    player = pkgs.callPackage ./modules/player.nix {};
    battery = pkgs.callPackage ./modules/battery.nix {};
    powermenu = pkgs.callPackage ./modules/powermenu.nix {};
    window = pkgs.callPackage ./modules/window.nix {};
    idle_inhibitor = pkgs.callPackage ./modules/idle_inhibitor.nix {};

    modules = [workspaces date tray clock player battery powermenu audio window idle_inhibitor];

    moduleConfig = {
      style = (lib.readFile ./style.css) + (lib.strings.concatStrings (builtins.map (m: m.style) modules));
      settings = lib.foldl lib.recursiveUpdate {} (builtins.map (m: m.settings) modules);
    };

    mainBar = {
      position = "top";
      modules-left = [
        (mkIf m.date date.name)
        window.name
      ];
      modules-center = [
        (mkIf m.player player.name)
      ];
      modules-right = [
        workspaces.name
        (mkIf m.audio audio.name)
        (mkIf m.battery battery.name)
        (mkIf m.clock clock.name)
        (mkIf m.powermenu powermenu.name)
        (mkIf m.idle_inhibitor idle_inhibitor.name)
        (mkIf m.tray tray.name)
      ];
    };
  in {
    programs.waybar = mkIf wb.enable {
      modules = {
        audio = lib.mkDefault true;
        clock = lib.mkDefault true;
        date = lib.mkDefault true;
        tray = lib.mkDefault true;
        powermenu = lib.mkDefault true;
        battery = lib.mkDefault true;
        player = lib.mkDefault true;
        idle_inhibitor = lib.mkDefault true;
      };
      style = moduleConfig.style;
      settings.mainBar = lib.recursiveUpdate mainBar moduleConfig.settings;
    };
  };
}
