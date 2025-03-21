{ lib, config, ... }:

{
  options = {
    shortcuts.enable = lib.mkEnableOption "enable shortcuts";
    shortcuts = {
      moodle.enable = lib.mkEnableOption "enable moodle shortcut";
    };
  };
  config =
    let
      cfg = config.shortcuts;
      mkShortcut = key: { name, url, icon ? null }: lib.mkIf cfg.${key}.enable {
        inherit name icon;
        exec = "xdg-open ${url}";
        terminal = false;
        comment = "Open ${name} in browser";
      };
    in
    lib.mkIf cfg.enable {
      xdg.desktopEntries = {
        moodle = mkShortcut "moodle" {
          name = "Moodle";
          url = "https://moodle.epfl.ch";
          icon = ./assets/EPFL.png;
        };
      };

      shortcuts.moodle.enable = lib.mkDefault true;
    };
}
