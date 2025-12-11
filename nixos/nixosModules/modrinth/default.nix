{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.programs.modrinth;
in {
  options.programs.modrinth = {
    enable = lib.mkEnableOption "enable Modrinth";
  };
  config = lib.mkIf cfg.enable {
    allowedUnfree = [
      "modrinth-app"
      "modrinth-app-unwrapped"
    ];
    environment.systemPackages = with pkgs; [modrinth-app];
  };
}
