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
    nixgl = {
      url = "github:nix-community/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
    gnome-mines-custom = {
      url = "github:ceedrich/gnome-mines/vim-keys";
      flake = false;
    };
    nix-minecraft.url = "github:Infinidoge/nix-minecraft";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    nixgl,
    ...
  } @ inputs: let
    utils = import ./utils.nix {};
    ceedrichLib = pkgs.callPackage ./lib {};
    system = "x86_64-linux";
    ceedrichPkgs = self.packages.${system};
    makePkgs = npkgs:
      import npkgs {
        inherit system;
        overlays = [
          (import inputs.rust-overlay)
          (final: prev: {
            rust-with-analyzer = prev.rust-bin.stable.latest.default.override {
              extensions = ["rust-src" "rust-analyzer" "clippy"];
            };
            ceedrichVim = inputs.ceedrichVim.packages.${system}.neovim;
          })
        ];
      };
    pkgs-unstable = makePkgs inputs.nixpkgs-unstable;
    pkgs = makePkgs nixpkgs;
    lib = pkgs.lib;

    hm-modules = [
      ./nixpkgs-issue-55674.nix
      ./homemanagerModules
      inputs.catppuccin.homeModules.catppuccin
      inputs.ceedrichVim.homeModules.${system}.default
    ];

    extraSpecialArgs = {
      meta = {inherit machines;};
      inherit
        inputs
        pkgs-unstable
        nixgl
        ceedrichLib
        ceedrichPkgs
        ;
    };

    machines = import ./machines.nix;

    mkNixos = hostname: users:
      nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit
            inputs
            pkgs-unstable
            ceedrichLib
            ceedrichPkgs
            ;
          meta = {
            inherit
              hostname
              machines
              system
              ;
          };
        };
        modules =
          [
            ./nixpkgs-issue-55674.nix
            ./globalHM.nix
            ./nixosModules
            ./homelab.nix
            ./hosts/_common
            ./hosts/${hostname}/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = false;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = extraSpecialArgs;
              home-manager.users = lib.genAttrs users (user: {
                imports =
                  [
                    {
                      home.username = user;
                      home.homeDirectory = "/home/${user}";
                      home.stateVersion = "24.11";
                    }
                  ]
                  ++ hm-modules;
              });
              global-hm.users = users;
            }
          ]
          ++ builtins.map (user: ./users/${user}) users;
      };
  in {
    nixosConfigurations = utils.generateConfigs mkNixos {
      jabba = ["ceedrich"];
      ahsoka = ["ceedrich"];
      satine = ["ceedrich"];
      jarjar = ["ceedrich"];
    };

    packages.${system} = import ./packages {inherit pkgs;};
  };
}
