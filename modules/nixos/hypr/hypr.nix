{self, ...}: {
  flake.nixosModules.hypr = {inputs', ...}: {
    imports = with self.nixosModules; [
      hyprlock
      hypridle
      hyprpolkitagent
      hyprsunset
      hyprtoolkit
    ];

    programs.hyprland = {
      # set the flake package
      package = inputs'.hyprland.packages.hyprland;
      # make sure to also set the portal package, so that they are in sync
      portalPackage = inputs'.hyprland.packages.xdg-desktop-portal-hyprland;
    };

    home-manager.sharedModules = [
      {
        wayland.windowManager.hyprland = {
          package = inputs'.hyprland.packages.hyprland;
          # make sure to also set the portal package, so that they are in sync
          portalPackage = inputs'.hyprland.packages.xdg-desktop-portal-hyprland;
        };
      }
    ];
  };
}
