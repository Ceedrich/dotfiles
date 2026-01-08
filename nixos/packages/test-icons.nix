{
  find-icons,
  libnotify,
  writeShellApplication,
}: let
  test-icons = writeShellApplication {
    name = "test-icons";
    runtimeInputs = [find-icons libnotify];
    text = ''
      icon="$(find-icons)"
      [[ -n "$icon" ]] || exit 1
      notify-send "test-icon" --icon="$icon"
      echo "$icon"
    '';
  };
in
  test-icons
