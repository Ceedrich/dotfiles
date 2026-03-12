{
  fd,
  handlr,
  uutils-findutils,
  writeShellApplication,
}: let
  rofi-file-picker = writeShellApplication {
    name = "rofi-file-picker";
    bashOptions = [];
    runtimeInputs = [
      fd
      handlr
      uutils-findutils
    ];
    text = builtins.readFile ./rofi-file-picker;
  };
in
  rofi-file-picker
