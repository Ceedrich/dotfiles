{
  pdfopen,
  rofi,
  fd,
  uutils-findutils,
  writeShellApplication,
}: let
  rofi-pdfmenu = writeShellApplication {
    name = "rofi-pdfmenu";
    runtimeInputs = [
      rofi
      pdfopen
      fd
      uutils-findutils
    ];
    text = ''
      fd --extension=pdf . "$HOME" | rofi -dmenu | xargs pdfopen
    '';
  };
in
  rofi-pdfmenu
