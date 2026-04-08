{self, ...}: {
  flake.nixosModules.base = {...}: {
    nixpkgs.overlays = [self.overlays.default];

    imports = [
      self.nixosModules.nixpkgs-issue-55674
      self.inputs.determinate.nixosModules.default
    ];
  };
}
