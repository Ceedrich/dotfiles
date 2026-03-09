{
  config,
  lib,
  ...
}: let
  paletteSource = lib.importJSON "${config.catppuccin.sources.palette}/palette.json";

  catppuccinColors = lib.pipe paletteSource [
    (lib.filterAttrs (n: v: n != "version"))
    (lib.mapAttrs (n: v: v.colors))
  ];

  cfg = config.catppuccin;

  palette = lib.mkOption {
    default = catppuccinColors;
    description = "The complete catppuccin palette";
    readOnly = true;
  };
  colors = lib.mkOption {
    default =
      cfg.palette.${cfg.flavor}
      // {
        accent = cfg.palette.${cfg.flavor}.${cfg.accent};
      };
    description = "The colors of the currently selected flavor";
    readOnly = true;
  };
in {
  options.catppuccin = {
    inherit colors palette;
  };
  config.home-manager.sharedModules = [
    {
      options.catppuccin = {inherit colors palette;};
    }
  ];
}
