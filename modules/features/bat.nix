{
  inputs,
  moduleWithSystem,
  ...
}: {
  perSystem = {pkgs, ...}: {
    packages.bat = inputs.wrappers.lib.wrapPackage ({...}: {
      inherit pkgs;
      package = pkgs.bat;
      env.BAT_THEME = "Catppuccin Mocha";
    });
  };

  flake.nixosModules.bat = moduleWithSystem ({self', ...}: {
    environment.systemPackages = [self'.packages.bat];
  });
}
