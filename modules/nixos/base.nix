{self, ...}: {
  flake.nixosModules.base = {...}: {
    nixpkgs.overlays = [self.overlays.default];

    imports = [
      self.nixosModules.standardPrograms
      self.nixosModules.nixpkgs-issue-55674
    ];
  };
}
