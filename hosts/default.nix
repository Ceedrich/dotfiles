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
          in {
            inherit inputs inputs' selfpkgs;
            inherit pkgs-unstable;
            meta = {inherit hostname;};
          };
          modules =
            [
              self.nixosModules.base
              ../nixosModules
              ../hosts/_common
              ../hosts/${hostname}/configuration.nix
              inputs.home-manager.nixosModules.home-manager
              inputs.catppuccin.nixosModules.catppuccin
              inputs.nix-flatpak.nixosModules.nix-flatpak
              {
                home-manager.useGlobalPkgs = false;
                home-manager.useUserPackages = true;
                home-manager.extraSpecialArgs = {inherit selfpkgs;};
                home-manager.sharedModules = [
                  self.homeModules.nixpkgs-issue-55674
                  inputs.catppuccin.homeModules.catppuccin
                  ../homemanagerModules
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
                global-hm.users = users;
              }
            ]
            ++ builtins.map (user: ../users/${user}) users;
        };
    in {
      jabba = mkNixos "jabba" ["ceedrich"];
      ahsoka = mkNixos "ahsoka" ["ceedrich"];
      satine = mkNixos "satine" ["ceedrich"];
      jarjar = mkNixos "jarjar" ["ceedrich"];
    });
}
