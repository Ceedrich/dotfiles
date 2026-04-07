{...}: {
  flake.nixosModules.clipboard = {
    config,
    lib,
    ...
  }: let
    cfg = config.services.clipboard;
  in {
    options.services.clipboard = {
      enable = lib.mkEnableOption "Clipboard";
    };

    config.home-manager.sharedModules = lib.mkIf cfg.enable [
      {
        services.cliphist.enable = true;
        services.wl-clip-persist.enable = true;
      }
    ];
  };
}
