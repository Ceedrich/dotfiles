{
  lib,
  config,
  ...
}: let
  cfg = config.shortcuts;
in {
  options.shortcuts = {
    moodle.enable = lib.mkEnableOption "enable moodle shortcut" // {default = true;};
    jellyfin.enable = lib.mkEnableOption "enable jellyfin shortcut" // {default = true;};
  };
  config.home-manager.sharedModules = [
    {
      xdg.desktopEntries = let
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
        moodle = mkShortcut "moodle" {
          name = "Moodle";
          url = "https://moodle.epfl.ch";
          icon = ../../assets/EPFL.png;
        };
      };
    }
  ];
}
