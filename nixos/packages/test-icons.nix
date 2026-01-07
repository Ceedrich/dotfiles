{
  find-icons,
  libnotify,
  writeShellApplication,
}: let
  test-icons = writeShellApplication {
    name = "test-icons";
    runtimeInputs = [find-icons libnotify];
    text = ''
      notify-send "test-icon" --icon="$(find-icons)"
    '';
  };
in
  test-icons
