{inputs, ...}: {
  flake.overlays.default = final: prev: let
    system = prev.stdenv.hostPlatform.system;
  in {
    ceedrichLib = final.callPackage ./lib {};
    ceedrichVim = inputs.ceedrichVim.packages.${system}.neovim;
    tailscale = inputs.nixpkgs-unstable.legacyPackages.${system}.tailscale;
  };
}
