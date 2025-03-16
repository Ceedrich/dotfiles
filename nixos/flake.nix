{
  description = "nixos flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    catppuccin.url = "github:catppuccin/nix";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }@inputs:
    let
      utils = import ./utils.nix { };
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        overlays = [
          (import inputs.rust-overlay)
          (final: prev: {
            rust-with-analyzer = prev.rust-bin.stable.latest.default.override {
              extensions = [ "rust-src" "rust-analyzer" ];
            };
          })
        ];
      };

      generateHomemanagerConfigs = utils.generateConfigs (name: home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          inputs.catppuccin.homeManagerModules.catppuccin
          ./users/${name}.nix
          ./homemanagerModules
        ];
      });

      generateNixosConfigs = utils.generateConfigs (host: nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/${host}/configuration.nix
          ./nixosModules
        ];
      });
    in
    {
      nixosConfigurations = generateNixosConfigs [
        "fun-machine"
      ];

      homeConfigurations = generateHomemanagerConfigs [
        "ceedrich"
        "ubuntu"
      ];
    };
}
