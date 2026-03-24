{
  config,
  lib,
  ...
}: let
  cfg = config.services.clipboard;
in {
  options.services.clipboard = {
    enable = lib.mkEnableOption "Clipboard";
  };

  config = lib.mkIf cfg.enable {
    home-manager.sharedModules = [
      {
        services.cliphist.enable = true;
        services.wl-clip-persist.enable = true;
      }
    ];
  };
}
