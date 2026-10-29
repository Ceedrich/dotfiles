{self, ...}: {
  flake.nixosModules.hypr-cshell = {inputs', ...}: let
    systemdTarget = "hyprland-session.target";
  in {
    imports = with self.nixosModules; [
      hypridle
      hyprland
      hyprlock
      hyprpolkitagent
      hyprsunset
      hyprtoolkit

      clipboard
      cshell
    ];

    services = {
      hypridle.systemdTargets = [systemdTarget];
      cliphist.systemdTargets = [systemdTarget];
      wl-clip-persist.systemdTargets = [systemdTarget];
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
