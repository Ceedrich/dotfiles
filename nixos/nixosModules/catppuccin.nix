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

  options = {
    palette = lib.mkOption {
      default = catppuccinColors;
      description = "The complete catppuccin palette";
      readOnly = true;
    };
    colors = lib.mkOption {
      default = let
        colors =
          cfg.palette.${cfg.flavor}
          // {
            accent = cfg.palette.${cfg.flavor}.${cfg.accent};
          };

        colorsExtended = lib.pipe colors [
          (lib.mapAttrsToList (
            name: color:
              [(lib.nameValuePair name color)]
              ++ (lib.forEach [10 20 30 40 50 60 70 80 90] (
                opacity:
                  lib.nameValuePair "${name}-${builtins.toString opacity}" {
                    inherit (color) order accent;
                    name = "${color.name}-${builtins.toString opacity}";
                    hex = "${color.hex}${lib.toHexString (opacity * 255 / 100)}";
                    hsla = color.hsl // {a = opacity / 100.0;};
                    rgba = color.rgb // {a = opacity / 100.0;};
                  }
              ))
          ))
          lib.flatten
          lib.listToAttrs
        ];
      in
        colorsExtended;
      description = "The colors of the currently selected flavor";
      readOnly = true;
    };

    colorsRasi = lib.mkOption {
      description = "The colors in rasi format";
      readOnly = true;
      default =
        ''* { ''
        + (lib.pipe cfg.colors [
          (lib.mapAttrsToList (name: value: ''${name}: ${value.hex};''))
          (lib.concatStringsSep "\n")
        ])
        + ''}'';
    };
    colorsGTK = lib.mkOption {
      description = "The colors in GTK format";
      readOnly = true;
      default = let
        mkRGB = color:
          if color?rgba
          then let inherit (color.rgba) r g b a; in "rgba(${toString r}, ${toString g}, ${toString b}, ${toString a})"
          else let inherit (color.rgb) r g b; in "rgb(${toString r}, ${toString g}, ${toString b})";
      in
        lib.pipe cfg.colors [
          (lib.mapAttrsToList (name: value: ''@define-color ${name} ${mkRGB value};''))
          (lib.concatStringsSep "\n")
        ];
    };
  };
in {
  options.catppuccin = options;
  config.home-manager.sharedModules = [
    {
      options.catppuccin = options;
    }
  ];
}
