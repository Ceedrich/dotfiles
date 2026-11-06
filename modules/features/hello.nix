{inputs, ...}: {
  perSystem = {pkgs, ...}: {
    packages.hello = inputs.wrappers.lib.wrapPackage {
      inherit pkgs;
      package = pkgs.hello;
      flags."--greeting" = "Hello There, General Kenobi";
    };
  };
}
