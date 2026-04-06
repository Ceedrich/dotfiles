{
  bash,
  fetchFromGitHub,
  gawk,
  gnutar,
  gzip,
  restic,
  unixtools,
  writeShellApplication,
}: let
  src = fetchFromGitHub {
    owner = "nicolaschan";
    repo = "minecraft-backup";
    rev = "970cb03";
    hash = "sha256-Xpi+E8kmHq4A2M8n6YgbT/j61ftnC22h6NsiNJ3VSdE=";
  };
in
  writeShellApplication {
    name = "minecraft-backup";
    runtimeInputs = [
      bash
      gawk
      gnutar
      gzip
      restic
      unixtools.xxd
    ];
    text = ''
      exec ${src}/backup.sh "$@"
    '';
  }
