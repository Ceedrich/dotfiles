{...}: {
  perSystem = {pkgs, ...}: {
    packages.system = pkgs.writeShellApplication {
      name = "system";
      runtimeInputs = with pkgs; [alejandra git];
      bashOptions = [];
      text = builtins.readFile ./system;
    };
  };
}
