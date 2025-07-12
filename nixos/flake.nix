{
  description = "nixos flake";

  inputs = {
    ceedrichVim.url = "github:Ceedrich/neovim-config";
    # disko = {
    #   url = "github:nix-community/disko";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixgl = {
      url = "github:nix-community/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
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

  outputs = { nixpkgs, home-manager, nixgl, ... }@inputs:
    let
      utils = import ./utils.nix { };
      system = "x86_64-linux";
      makePkgs = npkgs: import npkgs {
        inherit system;
        overlays = [
          (import inputs.rust-overlay)
          (final: prev: {
            rust-with-analyzer = prev.rust-bin.stable.latest.default.override {
              extensions = [ "rust-src" "rust-analyzer" "clippy" ];
            };
            ceedrichVim = inputs.ceedrichVim.packages.${system}.neovim;
          })
        ];
      };
      pkgs-unstable = makePkgs inputs.nixpkgs-unstable;
      pkgs = makePkgs nixpkgs;

      generateHomemanagerConfigs = utils.generateConfigs (name: home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = { inherit inputs pkgs-unstable nixgl; };

        modules = [
          inputs.catppuccin.homeModules.catppuccin
          ./nixpkgs-issue-55674.nix
          ./users/${name}.nix
          ./homemanagerModules
        ];
      });

      generateNixosConfigs = utils.generateConfigs (hostname: nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs pkgs-unstable;
          meta = { inherit hostname; };
        };
        modules = [
          ./nixpkgs-issue-55674.nix
          ./hosts/_common
          ./hosts/${hostname}/configuration.nix
          ./users/ceedrich
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
