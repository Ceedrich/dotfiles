{inputs, ...}: {
  perSystem = {pkgs, ...}: {
    packages.delta = inputs.wrappers.lib.wrapPackage {
      inherit pkgs;
      package = pkgs.delta;
      env.BAT_THEME = "Catppuccin Mocha";
    };
  };
}
