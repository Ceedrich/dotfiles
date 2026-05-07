{inputs, ...}: {
  flake.nixosModules.cshell = {pkgs, ...}: {
    environment.systemPackages = [inputs.cshell.packages.${pkgs.stdenv.hostPlatform.system}.default];
  };
}
