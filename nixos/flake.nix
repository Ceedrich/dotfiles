{
  description = "nixos flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    catppuccin.url = "github:catppuccin/nix";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    gnome-mines-custom = {
      url = "github:ceedrich/gnome-mines/vim-keys";
      flake = false;
    };
  };

  outputs = { nixpkgs, home-manager, ... }@inputs:
    let
      utils = import ./utils.nix { };
      system = "x86_64-linux";
      makePkgs = npkgs: import npkgs {
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
      pkgs-unstable = makePkgs inputs.nixpkgs-unstable;
      pkgs = makePkgs nixpkgs;

      generateHomemanagerConfigs = utils.generateConfigs (name: home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = { inherit inputs pkgs-unstable; };

        modules = [
          inputs.catppuccin.homeManagerModules.catppuccin
          ./nixpkgs-issue-55674.nix
          ./users/${name}.nix
          ./homemanagerModules
        ];
      });

      generateNixosConfigs = utils.generateConfigs (hostname: nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
          meta = { inherit hostname; };
        };
        modules = [
          ./hosts/${hostname}/configuration.nix
          ./nixosModules
        ];
      });
    in
    {
      nixosConfigurations = generateNixosConfigs [
        "fun-machine"
        "gaming"
      ];

      homeConfigurations = generateHomemanagerConfigs [
        "ceedrich"
        "ubuntu"
        "minimal"
      ];
    };
}
