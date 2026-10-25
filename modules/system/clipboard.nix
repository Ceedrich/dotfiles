{self, ...}: {
  flake.nixosModules.clipboard = {
    imports = with self.nixosModules; [cliphist wl-clip-persist];
  };
}
