{
  config,
  lib,
  ...
}: let
  cfg = config.programs.yazi;
  catppuccin = config.catppuccin;
in {
  config = lib.mkIf cfg.enable {
    programs.yazi = {
      settings.theme = lib.importTOML "${catppuccin.sources.yazi}/${catppuccin.flavor}/catppuccin-${catppuccin.flavor}-${catppuccin.accent}.toml";
    };
  };
}
