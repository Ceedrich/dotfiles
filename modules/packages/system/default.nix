{...}: {
  perSystem = {
    pkgs,
    self',
    ...
  }: {
    packages.system = pkgs.writeShellApplication {
      name = "system";
      runtimeInputs = [pkgs.alejandra self'.packages.git];
      bashOptions = [];
      text = builtins.readFile ./system;
    };
  };
}
