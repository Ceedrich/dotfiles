{self, ...}: {
  flake.nixosModules.hypr-cshell = let
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
  };
}
