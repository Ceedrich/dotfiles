{
  fd,
  fzf,
  huniq,
  writeShellApplication,
}: let
  find-icons = writeShellApplication {
    name = "find-icons";
    runtimeInputs = [
      fd
      fzf
      huniq
    ];
    text = ''
      IFS=: read -ra dirs <<< "$XDG_DATA_DIRS"
      for dir in "''${dirs[@]}"; do
        if ! [ -d "$dir" ]; then continue; fi
        fd . -L -e png -e svg "$dir" --format '{/.}'
      done | huniq | fzf
    '';
  };
in
  find-icons
