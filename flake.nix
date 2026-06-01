{
  description = "nixos flake";

  inputs = {
    pdfcat = {
      url = "github:pdfcat/pdfcat";
      flake = false;
    };
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    catppuccin = {
      url = "github:catppuccin/nix/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    mangowm = {
      url = "github:mangowm/mango";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    wrappers.url = "github:Lassulus/wrappers";
    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";

    hyprland.url = "github:hyprwm/hyprland/v0.55.2";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins/v0.55.0";
      inputs.hyprland.follows = "hyprland";
    };

    musnix.url = "github:musnix/musnix";
    nix-flatpak.url = "github:gmodena/nix-flatpak/latest";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    deploy-rs.url = "github:serokell/deploy-rs";

    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    nix-minecraft.url = "github:Infinidoge/nix-minecraft";
    cshell.url = "github:Ceedrich/cshell-qs";
    ceedrichVim.url = "github:Ceedrich/neovim-config";
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} (
      {...}: {
        systems = ["x86_64-linux"];
        imports = [
          ./hosts
          inputs.home-manager.flakeModules.home-manager
          (inputs.import-tree ./modules)
        ];
        perSystem = {pkgs, ...}: {
          formatter = pkgs.alejandra;
        };
      }
    );
}
