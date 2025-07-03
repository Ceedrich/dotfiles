{ python3, writeShellScriptBin, lib }:
let
  py = lib.getExe python3;
  serve-dir = writeShellScriptBin "serve-dir" ''
    ${py} -m http.server 8080
  '';
in
serve-dir
