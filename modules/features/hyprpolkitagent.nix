{
  flake.nixosModules.hyprpolkitagent = {
    pkgs,
    lib,
    ...
  }: {
    environment.systemPackages = [pkgs.hyprpolkitagent];
    systemd.user.services."hyprpolkitagent" = {
      enable = true;
      after = lib.mkForce [];
    };
  };
}
