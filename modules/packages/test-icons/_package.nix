{
  wayland_support ? true,
  x11_support ? true,
  lib,
  find-icons,
  libnotify,
  wl-clipboard,
  writeShellApplication,
  xclip,
}: let
  test-icons = writeShellApplication {
    name = "test-icons";
    runtimeInputs =
      [find-icons libnotify]
      ++ lib.optional wayland_support wl-clipboard
      ++ lib.optional x11_support xclip;
    text = ''
      CLIPBOARD=""

      usage() {
        echo "Usage: $0 [options]"
        echo ""
        echo "Display a notification with an icon and copy the icon name to stdoud or clipboard"
        echo ""
        echo "Options: "
        echo "-h    Show this help message and exit"
        echo "-c    Copy icon name to the clipboard (requires wl-copy or xclip)"
      }

      fatal () {
        code="$1"; shift
        echo "$@" 1>&2
        exit "$code"
      }

      copy() {
        local text="$1"
        if [[ -n $WAYLAND_DISPLAY ]] || [[ "$XDG_SESSION_TYPE" == "wayland" ]]; then
          command -v wl-copy >/dev/null 2>&1 || fatal 2 "'wl-copy' not found"
          wl-copy "$text"
        else
          command -v xclip >/dev/null 2>&1 || fatal 2 "'xclip' not found"
          echo -n "$text" | xclip -selection clipboard
        fi
      }

      while getopts "hc" opt; do
        case "$opt" in
          h) usage; exit ;;
          c) CLIPBOARD="yes" ;;
          *) usage; exit 1
        esac
      done

      icon="$(find-icons)"
      [[ -n "$icon" ]] || exit 1
      notify-send "test-icon" --icon="$icon"

      if [[ -n $CLIPBOARD ]]; then
        copy "$icon"
      else
        echo "$icon"
      fi
    '';
  };
in
  test-icons
