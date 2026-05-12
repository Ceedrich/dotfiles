{self, ...}: {
  flake.nixosModules.hypr = {
    imports = with self.nixosModules; [
      hyprlock
      hyprpaper
      hypridle
      hyprpolkitagent
      hyprsunset
      hyprtoolkit
    ];
  };
}
