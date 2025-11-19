{
  waylandSupport ? true,
  xserverSupport ? true,
  rofi-wayland,
  pkgs,
  wtype,
  gnused,
  xdotool,
  lib,
}: let
in
  pkgs.writeShellApplication {
    name = "passmenu";
    runtimeInputs =
      [
        rofi-wayland
        gnused
      ]
      ++ lib.optional waylandSupport wtype
      ++ lib.optional xserverSupport xdotool;
    text = builtins.readFile ./passmenu;
  }
