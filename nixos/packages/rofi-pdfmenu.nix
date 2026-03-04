{
  pdfopen,
  rofi,
  fd,
  uutils-findutils,
  writeShellApplication,
  makeDesktopItem,
  symlinkJoin,
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
      PDFMENU_HOME=''${PDFMENU_HOME:-$HOME}
      fd --extension=pdf . "$PDFMENU_HOME" \
        --exec printf '%s\0icon\x1fapplication-pdf\n' \
        | rofi -show-icons -dmenu -i -format "q" -p "Open PDF" \
        | xargs pdfopen
    '';
  };

  desktopItem = makeDesktopItem {
    name = "rofi-pdfmenu";
    desktopName = "Open PDF";
    exec = "rofi-pdfmenu";
    icon = "application-pdf";
    categories = ["Utility"];
  };
in
  symlinkJoin {
    name = "rofi-pdfmenu";
    paths = [desktopItem rofi-pdfmenu];
  }
