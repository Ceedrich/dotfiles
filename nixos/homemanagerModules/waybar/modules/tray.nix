{lib, ...}: {
  options.programs.waybar.modules.tray = {
    enable = lib.mkOption {
      description = "enable tray module";
      default = true;
      type = lib.types.bool;
    };
  };
  config.programs.waybar = {
    settings.mainBar."tray" = {
      icon-size = 21;
      spacing = 8;
    };
    style =
      #css
      ''
        #tray {
            padding: 0px 8px;
        }
      '';
  };
}
