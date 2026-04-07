{writeShellScriptBin}: let
  space = writeShellScriptBin "space" ''
    space() {
      du -xahd1 "$1" | sort -hr | head
    }

    space "''${1:-.}"
  '';
in
  space
