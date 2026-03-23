{inputs, ...}: {
  flake.overlays.default = final: prev: let
    system = prev.stdenv.hostPlatform.system;
  in {
    ceedrichLib = final.callPackage ./lib {};
    ceedrichVim = inputs.ceedrichVim.packages.${system}.neovim;
    tailscale = inputs.nixpkgs-unstable.legacyPackages.${system}.tailscale;
    rofi = prev.rofi.overrideAttrs (old: {
      postInstall =
        old.postInstall or ""
        + ''
          ln -s $out/bin/rofi $out/bin/dmenu
        '';
    });
  };
}
