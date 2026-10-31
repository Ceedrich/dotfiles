{
  config,
  lib,
  inputs,
  ...
}: let
  paletteSource = lib.importJSON "${inputs.catppuccin-palette}/palette.json";

  catppuccinColors = lib.pipe paletteSource [
    (lib.filterAttrs (n: v: n != "version"))
    (lib.mapAttrs (n: v: v.colors))
  ];

  cfg = config.flake.catppuccin;

  options = {
    # From <https://github.com/catppuccin/nix/blob/feac189528d08ca7c46bf1605d84b78ea5fe8263/modules/lib/default.nix#L28-L52>
    flavor = lib.mkOption {
      type = lib.types.enum ["latte" "frappe" "macchiato" "mocha"];
      default = "mocha";
    };
    accent = lib.mkOption {
      type = lib.types.enum [
        "blue"
        "flamingo"
        "green"
        "lavender"
        "maroon"
        "mauve"
        "peach"
        "pink"
        "red"
        "rosewater"
        "sapphire"
        "sky"
        "teal"
        "yellow"
      ];
      default = "mauve";
    };
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
  };
in {
  options.flake.catppuccin = options;
}
