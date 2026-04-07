{self, ...}: {
  flake.nixosModules.zathura = {
    lib,
    config,
    ...
  }: let
    cfg = config.programs.zathura;
  in {
    options.programs.zathura = {
      enable = lib.mkEnableOption "enable zathura";
    };
    config = lib.mkIf cfg.enable {
      xdg.mime.defaultApplications."application/pdf" = ["org.pwmt.zathura-pdf-mupdf.desktop"];

      home-manager.sharedModules = with self.homeModules; [zathura];
    };
  };

  flake.homeModules.zathura = {
    programs.zathura = {
      enable = true;
      extraConfig = ''
        set selection-clipboard clipboard
      '';
    };
  };
}
