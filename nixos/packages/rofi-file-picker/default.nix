{
  fd,
  xdg-utils,
  uutils-findutils,
  writeShellApplication,
}: let
  rofi-file-picker = writeShellApplication {
    name = "rofi-file-picker";
    bashOptions = [];
    runtimeInputs = [
      fd
      xdg-utils
      uutils-findutils
    ];
    text = builtins.readFile ./rofi-file-picker;
  };
in
  rofi-file-picker
