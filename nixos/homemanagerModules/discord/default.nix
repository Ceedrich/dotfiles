{
  lib,
  config,
  ...
}: let
  cfg = config.programs.discord;
in {
  config = lib.mkIf cfg.enable {
    allowedUnfree = ["discord"];
  };
}
