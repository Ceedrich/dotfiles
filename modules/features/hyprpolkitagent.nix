{
  flake.nixosModules.hyprpolkitagent = {pkgs, ...}: {
    environment.systemPackages = [pkgs.hyprpolkitagent];
  };
}
