{
  description = "nixos flake";

  inputs = {
    ceedrichVim.url = "github:Ceedrich/neovim-config";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    catppuccin = {
      url = "github:catppuccin/nix/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-minecraft.url = "github:Infinidoge/nix-minecraft";
    deploy-rs.url = "github:serokell/deploy-rs";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    deploy-rs,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    overlays = let
      ceedrichVim = inputs.ceedrichVim.packages.${system}.neovim;
      tailscale = inputs.nixpkgs-unstable.legacyPackages.${system}.tailscale;
    in [
      inputs.rust-overlay.overlays.default
      (final: prev: {
        rust-with-analyzer = prev.rust-bin.stable.latest.default.override {
          extensions = ["rust-src" "rust-analyzer" "clippy"];
        };
        inherit ceedrichVim tailscale;
        ceedrichLib = final.callPackage ./lib {};
      })
    ];
    ceedrichPkgs = self.packages.${system};

    extraSpecialArgs = {
      inherit ceedrichPkgs;
    };

    mkNixos = hostname: users:
      nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
          inherit ceedrichPkgs;
          meta = {inherit hostname;};
        };
        modules =
          [
            {nixpkgs.overlays = overlays;}
            ./nixpkgs-issue-55674.nix
            ./globalHM.nix
            ./nixosModules
            ./hosts/_common
            ./hosts/${hostname}/configuration.nix
            home-manager.nixosModules.home-manager
            inputs.catppuccin.nixosModules.catppuccin
            {
              home-manager.useGlobalPkgs = false;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = extraSpecialArgs;
              home-manager.users = nixpkgs.lib.genAttrs users (user: {
                imports = [
                  {
                    home.username = user;
                    home.homeDirectory = "/home/${user}";
                    home.stateVersion = "24.11";
                  }
                  ./nixpkgs-issue-55674.nix
                  ./homemanagerModules
                  inputs.catppuccin.homeModules.catppuccin
                  inputs.ceedrichVim.homeModules.${system}.default
                ];
              });
              global-hm.users = users;
            }
          ]
          ++ builtins.map (user: ./users/${user}) users;
      };
    mkDeployNode = hostname: {
      sshUser,
      user ? "root",
      interactiveSudo ? true,
    }: let
      host = self.nixosConfigurations.${hostname};
    in {
      inherit hostname;
      profiles.system = {
        inherit sshUser user interactiveSudo;
        path =
          deploy-rs.lib.${host.pkgs.stdenv.hostPlatform.system}.activate.nixos host;
      };
    };
  in {
    nixosConfigurations = {
      jabba = mkNixos "jabba" ["ceedrich"];
      ahsoka = mkNixos "ahsoka" ["ceedrich"];
      satine = mkNixos "satine" ["ceedrich"];
      jarjar = mkNixos "jarjar" ["ceedrich"];
    };

    deploy = {
      remoteBuild = true;
      nodes = {
        jabba = mkDeployNode "jabba" {sshUser = "ceedrich";};
        jarjar = mkDeployNode "jarjar" {sshUser = "ceedrich";};
      };
    };

    packages.${system} = import ./packages {pkgs = import nixpkgs {inherit system;};};

    checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
  };
}
