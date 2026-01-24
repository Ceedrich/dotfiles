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
    withSystem system ({
      config,
      inputs',
      ...
    }: let
      ceedrichPkgs = config.packages;
      mkNixos = hostname: users:
        inputs.nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs inputs';
            inherit ceedrichPkgs;
            meta = {inherit hostname;};
          };
          modules =
            [
              {nixpkgs.overlays = [self.overlays.default];}
              ../nixpkgs-issue-55674.nix
              ../nixosModules
              ../hosts/_common
              ../hosts/${hostname}/configuration.nix
              inputs.home-manager.nixosModules.home-manager
              inputs.catppuccin.nixosModules.catppuccin
              {
                home-manager.useGlobalPkgs = false;
                home-manager.useUserPackages = true;
                home-manager.extraSpecialArgs = {inherit ceedrichPkgs;};
                home-manager.sharedModules = [
                  ../nixpkgs-issue-55674.nix
                  ../homemanagerModules
                  inputs.catppuccin.homeModules.catppuccin
                  inputs.ceedrichVim.homeModules.${system}.default
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
