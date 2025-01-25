{
  description = "Home Manager configuration of ceedrich";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    catppuccin.url = "github:catppuccin/nix";
  };

  outputs = { nixpkgs, home-manager, catppuccin, ... }@inputs:
    let
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
    in
    {
      homeConfigurations."ceedrich" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [ ./home.nix catppuccin.homeManagerModules.catppuccin ];

        extraSpecialArgs = { inherit inputs; };
      };
    };
}
