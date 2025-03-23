{ pkgs ? import <nixpkgs> }:
let
  name = "confirm-dialogue";
  dmenuCommand = "${pkgs.rofi-wayland}/bin/rofi -dmenu -i -l 2 -p";
in
pkgs.writeShellApplication {
  inherit name;
  text = ''
    if [ $# -ne 2 ]; then 
      echo "Usage: ${name} [title] [command]"
      exit 1
    fi
    text="Are you sure? ($1)"
    result=$(echo -e "Yes\nNo" | ${dmenuCommand} "$text")

    case "$result" in
      Yes)
        eval "$2";;
    esac
  '';
}
