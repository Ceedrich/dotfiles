{
  pkgs ? import <nixpkgs>,
  lib ? pkgs.lib,
  name ? "custom/player",
}: {
  ${name} = {
    orientation = "inherit";
    format = "  {}";
    escape = true;
    interval = 5;
    tooltip = false;
    exec = "playerctl metadata --format='{{ artist }} - {{ title }}'";
    on-click = "playerctl play-pause";
    max-length = 50;
  };
}
