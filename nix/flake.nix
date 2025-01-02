{
  description = "A flake building my nix system";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs }:
  let 
    system = "x86_64-linux";
    pgks = import nixpkgs {
      inherit system;
    };
  in
  {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit system; };
      modules = [ ./configuration.nix ];
    };
  };
}
