{
  pkgs-unstable,
  modulesPath,
  inputs,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    inputs.disko.nixosModules.disko
    ./disk-config.nix
    ./minecraft-servers
    ./hardware-configuration.nix
  ];

  system.stateVersion = "24.11";

  services.tailscale.enable = true;
  services.tailscale.package = pkgs-unstable.tailscale;
}
