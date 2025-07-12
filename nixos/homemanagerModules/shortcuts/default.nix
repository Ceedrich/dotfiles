{
  lib,
  config,
  ...
}: {
  options.shortcuts = {
    moodle.enable = lib.mkEnableOption "enable moodle shortcut";
    jellyfin.enable = lib.mkEnableOption "enable jellyfin shortcut";
  };
  config = let
    cfg = config.shortcuts;
    mkShortcut = key: {
      name,
      url,
      icon ? null,
    }:
      lib.mkIf cfg.${key}.enable {
        inherit name icon;
        exec = "xdg-open ${url}";
        terminal = false;
        comment = "Open ${name} in browser";
      };
  in {
    xdg.desktopEntries = {
      moodle = mkShortcut "moodle" {
        name = "Moodle";
        url = "https://moodle.epfl.ch";
        icon = ./assets/EPFL.png;
      };
      jellyfin = mkShortcut "jellyfin" {
        name = "Jellyfin";
        url = "http://fun-machine";
      };
    };

    shortcuts.moodle.enable = lib.mkDefault true;
    shortcuts.jellyfin.enable = lib.mkDefault true;
  };
}
