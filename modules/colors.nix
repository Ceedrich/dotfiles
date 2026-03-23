{
  inputs,
  lib,
  ...
}: let
  paletteSource = lib.importJSON "${inputs.catppuccin.packages."x86_64-linux".palette}/palette.json";

  palette = lib.pipe paletteSource [
    (lib.filterAttrs (n: v: n != "version"))
    (lib.mapAttrs (n: v: v.colors))
  ];

  flavor = "mocha";
  accent = "mauve";
in {
  options.catppuccin = {
    flavor = lib.mkOption {
      type = lib.types.str;
      default = "mocha";
    };
    colors = lib.mkOption {
      default = let
        colors =
          palette.${flavor}
          // {
            accent = palette.${flavor}.${accent};
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
  };
}
