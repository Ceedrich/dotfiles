{
  withSystem,
  self,
  inputs,
  ...
}: {
  imports = [./deployments.nix];
  flake.nixosConfigurations = let
    system = "x86_64-linux";
  in
    withSystem system ({inputs', ...}: let
      selfpkgs = self.packages.${system};
      mkNixos = hostname: users:
        inputs.nixpkgs.lib.nixosSystem {
          specialArgs = let
            pkgs-unstable = import inputs.nixpkgs-unstable {inherit system;};
            selfnixosmodules = self.nixosModules;
          in {
            inherit inputs inputs' selfpkgs selfnixosmodules; # Pass in until fully migrated to dendritic pattern
            inherit pkgs-unstable;
            meta = {inherit hostname;};
          };
          modules =
            [
              self.nixosModules.oh-my-posh
              self.nixosModules.base
              ../nixosModules
              ../hosts/_common
              ../hosts/${hostname}/configuration.nix
              inputs.home-manager.nixosModules.home-manager
              inputs.catppuccin.nixosModules.catppuccin
              inputs.nix-flatpak.nixosModules.nix-flatpak
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.extraSpecialArgs = {inherit selfpkgs;};
                home-manager.sharedModules = [
                  inputs.catppuccin.homeModules.catppuccin
                ];
                home-manager.users = inputs.nixpkgs.lib.genAttrs users (user: {
                  imports = [
                    {
                      home.username = user;
                      home.homeDirectory = "/home/${user}";
                      home.stateVersion = "24.11";
                    }
                  ];
                });
              }
            ]
            ++ builtins.map (user: self.nixosModules."user-${user}") users;
        };
    in {
      jabba = mkNixos "jabba" ["ceedrich"];
      ahsoka = mkNixos "ahsoka" ["ceedrich"];
      satine = mkNixos "satine" ["ceedrich"];
      jarjar = mkNixos "jarjar" ["ceedrich"];
    });
}
