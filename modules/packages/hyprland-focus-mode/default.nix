{...}: {
  perSystem = {pkgs, ...}: {
    packages.hyprland-focus-mode = pkgs.writeShellApplication {
      name = "hyprland-focus-mode";
      text = builtins.readFile ./hyprland-focus-mode;
      bashOptions = [];
    };
  };
}
