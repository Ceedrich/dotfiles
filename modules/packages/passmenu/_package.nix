{
  waylandSupport ? true,
  xserverSupport ? true,
  rofi,
  pkgs,
  wtype,
  gnused,
  xdotool,
  lib,
}: let
in
  pkgs.writeShellApplication {
    name = "passmenu";
    bashOptions = [];
    runtimeInputs =
      [
        rofi
        gnused
      ]
      ++ lib.optional waylandSupport wtype
      ++ lib.optional xserverSupport xdotool;
    text = builtins.readFile ./passmenu;
  }
