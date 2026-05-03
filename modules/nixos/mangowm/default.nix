{inputs, ...}: {
  flake.nixosModules.mangowm = {
    imports = [inputs.mangowm.nixosModules.mango];
    programs.mango.enable = true;

    home-manager.sharedModules = [
      inputs.mangowm.hmModules.mango
      {
        wayland.windowManager.mango = {
          enable = true;
          systemd = {
            enable = true;
            xdgAutostart = true;
          };
        };
      }
    ];
  };
}
