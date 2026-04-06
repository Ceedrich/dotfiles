{
  inputs,
  self,
  ...
}: {
  flake.overlays.default = final: prev: let
    system = prev.stdenv.hostPlatform.system;
  in {
    ceedrichLib = self.lib;
    ceedrichVim = inputs.ceedrichVim.packages.${system}.neovim;
    tailscale = inputs.nixpkgs-unstable.legacyPackages.${system}.tailscale;
    rofi = prev.rofi.overrideAttrs (old: {
      postInstall =
        old.postInstall or ""
        + ''
          ln -s $out/bin/rofi $out/bin/dmenu
        '';
    });
    hyprshutdown = inputs.nixpkgs-unstable.legacyPackages.${system}.hyprshutdown;
    makeModrinthPrefetcher = final.callPackage ./_modrinth-prefetch.nix {};
  };
}
