{
  rofi-wayland,
  pkgs,
  wtype,
  gnused,
}: let
in
  pkgs.writeShellApplication {
    name = "passmenu";
    runtimeInputs = [rofi-wayland wtype gnused];
    text = builtins.readFile ./passmenu;
  }
