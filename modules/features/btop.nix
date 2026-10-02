{inputs, ...}: {
  perSystem = {
    pkgs,
    inputs',
    ...
  }: {
    packages.btop = inputs.wrappers.wrappers.btop.wrap {
      inherit pkgs;
      settings.vim_keys = true;
      settings.color_theme = "catppuccin_mocha";
      overrides = [
        (pkg: pkg.override {rocmSupport = true;})
      ];
      themes."catppuccin_mocha" = builtins.readFile "${inputs'.catppuccin.packages.btop}/catppuccin_mocha.theme";
    };
  };
}
