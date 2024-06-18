#!/usr/bin/env bash

uptime="$(uptime -p | sed -e 's/up //g')"
theme="${XDG_CONFIG_HOME:-$HOME/.config}/rofi/scripts/powermenu-theme.rasi"

# Icons
shutdown=󰐥
reboot=󰜉
logout=󰍃
yes=y
no=n

run_rofi() {
  echo -e "$shutdown\n$reboot\n$logout" | rofi -dmenu -filter "" \
    -mesg "Power Menu (up $uptime)" \
    -theme "$theme"
}

confirm_exit() {
  echo -e "$yes\n$no" | rofi -dmenu \
    -mesg "Are you sure ($1)" \
    -theme "$theme"
}

run_cmd() {
  selected="$(confirm_exit "$1")"
  if [ "$selected" == "$yes" ]; then
    if [ "$1" == "Shutdown" ]; then
      systemctl poweroff
    elif [ "$1" == "Reboot" ]; then
      systemctl reboot
    elif [ "$1" == "Logout" ]; then
      i3-msg exit
    fi
  else
    exit 0
  fi
}

chosen="$(run_rofi)"
case "$chosen" in
  "$shutdown")
    run_cmd Shutdown
    ;;
  "$reboot")
    run_cmd Reboot
    ;;
  "$logout")
    run_cmd Logout
    ;;
esac
