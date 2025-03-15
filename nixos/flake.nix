{
  description = "nixos flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      nixosConfigurations.fun-machine = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/fun-machine/configuration.nix
          ./modules
        ];
      };

      homeConfigurations.default = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        modules = [
          ./homemanagerModules
        ];
      };
    };
}
