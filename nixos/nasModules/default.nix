{inputs, ...}: {
  imports = [
    inputs.disko.nixosModules.disko
    ./drives.nix
  ];
}
