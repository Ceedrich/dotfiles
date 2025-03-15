{
  description = "nixos flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
  };

  outputs = { nixpkgs, ... }@inputs: {
    nixosConfigurations.fun-machine = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = [
        ./hosts/fun-machine/configuration.nix
        ./modules
      ];
    };
  };
}
