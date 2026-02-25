{
  lib,
  pdfViewer ? zathura,
  zathura,
  writeShellApplication,
}: let
  pdfopen = writeShellApplication {
    name = "pdfopen";
    text = ''
      if [[ ( $# == 0 ) ]]; then
        echo "usage: pdfopen [...args for ${pdfViewer.name}]" >&2
        exit 1
      fi

      ${lib.getExe pdfViewer} "$@" >/dev/null 2>&1 & disown
    '';
  };
in
  pdfopen
