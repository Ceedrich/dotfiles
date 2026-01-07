{
  description = "nixos flake";

  inputs = {
    ceedrichVim.url = "github:Ceedrich/neovim-config";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url = "github:hyprwm/Hyprland";
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
    nixpkgs,
    home-manager,
    nixgl,
    ...
  } @ inputs: let
    utils = import ./utils.nix {};
    ceedrichLib = pkgs.callPackage ./lib {};
    system = "x86_64-linux";
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
        ;
    };

    mkHomeManager = dir: user:
      home-manager.lib.homeManagerConfiguration {
        inherit pkgs extraSpecialArgs;

        modules =
          [
            {
              home.username = user;
              home.homeDirectory = "/home/${user}";
              home.stateVersion = "24.11";
            }
            ./users/${dir}/dotfiles.nix
          ]
          ++ hm-modules;
      };

    machines = import ./machines.nix;

    mkNixos = hostname: users:
      nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit
            inputs
            pkgs-unstable
            ceedrichLib
            ;
          meta = {
            inherit
              hostname
              machines
              system
              ;
          };
        };
        modules = [
          ./nixpkgs-issue-55674.nix
          ./nixosModules
          ./hosts/_common
          ./hosts/${hostname}/configuration.nix
          ./users/ceedrich
          ./globalHM.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = false;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = extraSpecialArgs;
            home-manager.users =
              pkgs.lib.mapAttrs (user: dir: {
                imports =
                  [
                    {
                      home.username = user;
                      home.homeDirectory = "/home/${user}";
                      home.stateVersion = "24.11";
                    }
                    ./users/${dir}/dotfiles.nix
                  ]
                  ++ hm-modules;
              })
              users;
          }
          {
            global-hm.users = pkgs.lib.attrNames users;
          }
        ];
      };
  in {
    nixosConfigurations = utils.generateConfigs mkNixos {
      jabba = {"ceedrich" = "minimal";};
      ahsoka = {"ceedrich" = "ceedrich";};
      satine = {"ceedrich" = "ceedrich";};
      jarjar = {"ceedrich" = "minimal";};
    };

    homeConfigurations = utils.generateConfigs mkHomeManager {
      "ceedrich" = "ceedrich";
      "ubuntu" = "ceedrich";
      "minimal" = "ceedrich";
    };

    packages.${system} = rec {
      "find-icons" = pkgs.callPackage ./packages/find-icons.nix {};
      "test-icons" = pkgs.callPackage ./packages/test-icons.nix {inherit find-icons;};
      "rebuild-system" = pkgs.callPackage ./packages/rebuild_system.nix {};
      "minecraft-backup" = pkgs.callPackage ./packages/minecraft-backup.nix {};
    };
  };
}
