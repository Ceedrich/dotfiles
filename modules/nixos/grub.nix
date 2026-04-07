{...}: {
  flake.nixosModules.grub = {
    config,
    lib,
    ...
  }: {
    boot.loader.grub = let
      catppuccinGrub = config.catppuccin.sources.grub.overrideAttrs {
        patchPhase = ''
          cp ${../../assets/Ceedrich/Ceedrich-100x100.png} src/catppuccin-${config.catppuccin.flavor}-grub-theme/logo.png
        '';
      };
    in {
      enable = true;
      device = "nodev"; # Using UEFI System
      efiSupport = true;
      theme = lib.mkForce "${catppuccinGrub}/share/grub/themes/catppuccin-${config.catppuccin.flavor}-grub-theme";
    };
  };
}
