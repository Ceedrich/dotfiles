{
  pdfopen,
  rofi,
  fd,
  findutils,
  writeShellApplication,
}: let
  pdfmenu = writeShellApplication {
    runtimeInputs = [
      rofi
      pdfopen
      fd
      findutils
    ];
    text = ''
      if [[ -z $SEARCH_DIR ]]; SEARCH_DIR="$HOME"
      fd --extension=pdf . $SEARCH_DIR | rofi -dmenu -p "Open PDF" -i -format q | xargs pdfopen
    '';
  };
in
  pdfmenu
