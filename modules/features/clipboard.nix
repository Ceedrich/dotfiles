{
  flake.nixosModules.clipboard = {
    config.home-manager.sharedModules = [
      {
        services.cliphist.enable = true;
        services.wl-clip-persist.enable = true;
      }
    ];
  };
}
