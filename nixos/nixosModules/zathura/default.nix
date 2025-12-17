{
  pkgs,
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
    environment.systemPackages = with pkgs; [zathura];
    global-hm.config.programs.zathura.enable = lib.mkDefault true;
  };
}
