{inputs, ...}: {
  perSystem = {
    pkgs,
    inputs',
    ...
  }: {
    packages.foot = inputs.wrappers.wrappers.foot.wrap {
      inherit pkgs;
      settings = {
        main = {
          font = "JetBrains Mono Nerd Font:size=12";
          title = "Terminal";
        };
        key-bindings = {
          scrollback-up-half-page = "Control+Shift+k";
          scrollback-down-half-page = "Control+Shift+j";
        };
      };
      constructFiles.generatedConfig.content = builtins.readFile "${inputs'.catppuccin.packages.foot}/catppuccin-mocha.ini";
    };
  };
}
