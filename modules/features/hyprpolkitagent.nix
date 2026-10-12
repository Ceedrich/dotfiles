{
  flake.nixosModules.hyprpolkitagent = {pkgs, ...}: {
    environment.systemPackages = [pkgs.hyprpolkitagent];
    systemd.packages = [pkgs.hyprpolkitagent];
    systemd.user.services."hyprpolkitagent".enable = true;
  };
}
