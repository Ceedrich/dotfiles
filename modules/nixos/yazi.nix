{...}: {
  flake.nixosModules.yazi = {
    config,
    lib,
    ...
  }: let
    cfg = config.programs.yazi;
    catppuccin = config.catppuccin;
  in {
    config = lib.mkIf cfg.enable {
      programs.yazi = {
        # From <https://github.com/catppuccin/nix/blob/main/modules/home-manager/yazi.nix>
        settings.theme = lib.mkMerge [
          (lib.importTOML "${catppuccin.sources.yazi}/${catppuccin.flavor}/catppuccin-${catppuccin.flavor}-${catppuccin.accent}.toml")
          {
            mgr.syntect_theme = lib.mkForce "${catppuccin.sources.bat}/Catppuccin ${lib.toSentenceCase catppuccin.flavor}.tmTheme";
          }
        ];
      };

      xdg.mime.defaultApplications = {"inode/directory" = "yazi.desktop";};
    };
  };
}
