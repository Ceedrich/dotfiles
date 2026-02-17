{
  rofi,
  writeShellApplication,
}: let
in
  writeShellApplication rec {
    name = "rofi-confirm-dialogue";
    text = ''
      if [ $# -lt 2 ]; then
        echo "Usage: ${name} [title] [command]"
        exit 1
      fi
      action="$1"; shift
      text="Are you sure? ($action)"
      result=$(echo -e "Yes\nNo" | ${rofi}/bin/rofi -dmenu -i -l 2 -p "$text")

      case "$result" in
        Yes)
          "$@";;
      esac
    '';
  }
