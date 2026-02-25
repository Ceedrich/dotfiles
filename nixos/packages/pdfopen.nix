{
  lib,
  pdfViewer ? zathura,
  zathura,
  writeShellApplication,
}: let
  viewer = pdfViewer.meta.mainProgram or pdfViewer.pname or pdfViewer.name or "pdfViewer";

  pdfopen = writeShellApplication {
    name = "pdfopen";
    text = ''
      if [[ ( $# == 0 ) ]]; then
        echo "usage: pdfopen [...args for ${viewer}]" >&2
        exit 1
      fi

      ${lib.getExe pdfViewer} "$@" >/dev/null 2>&1 & disown
    '';
  };
in
  pdfopen
