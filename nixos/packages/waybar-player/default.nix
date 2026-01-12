{
  writeShellApplication,
  playerctl,
  jq,
  hyprland,
}: let
  waybar-player = writeShellApplication {
    name = "waybar-player";
    bashOptions = [];
    runtimeInputs = [playerctl jq hyprland];
    text = builtins.readFile ./waybar-player;
  };
in
  waybar-player
