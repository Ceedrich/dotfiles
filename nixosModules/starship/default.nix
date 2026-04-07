{
  config,
  lib,
  ...
}: let
  cfg = config.programs.starship;
in {
  config = lib.mkIf cfg.enable {
    programs.starship = {
      interactiveOnly = true;
      settings =
        lib.importTOML ./starship.toml
        // rec {
          palette = "catppuccin_${config.catppuccin.flavor}";
          palettes.${palette} = lib.mapAttrs (n: clr: clr.hex) config.catppuccin.colors;
        };
    };
  };
}
