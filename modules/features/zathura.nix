{
  inputs,
  moduleWithSystem,
  ...
}: {
  flake.nixosModules.zathura = moduleWithSystem ({self', ...}: {
    xdg.mime.defaultApplications."application/pdf" = ["org.pwmt.zathura-pdf-mupdf.desktop"];

    environment.systemPackages = [self'.packages.zathura];
  });

  perSystem = {
    pkgs,
    inputs',
    ...
  }: {
    packages.zathura = inputs.wrappers.wrappers.zathura.wrap {
      inherit pkgs;
      settings = {
        selection-clipboard = "clipboard";
        scroll-step = 80;
        scroll-page-aware = true;
      };
      extraSettings = ''
        include ${inputs'.catppuccin.packages.zathura}/catppuccin-mocha
      '';
    };
  };
}
