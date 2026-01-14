{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.programs.nautilus;
in {
  options.programs.nautilus = {
    enable = lib.mkEnableOption "Nautilus";
    package = lib.mkPackageOption pkgs "nautilus" {};
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [cfg.package];

    services.gvfs.enable = true;
    programs.nautilus-open-any-terminal.enable = true;
    services.gnome.sushi.enable = true;
  };
}
