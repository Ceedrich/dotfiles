{
  pkgs ? import <nixpkgs>,
  lib ? pkgs.lib,
  name ? "group/player",
}: let
  prev = "custom/player-prev";
  next = "custom/player-next";
  main = "custom/player-main";
in {
  ${name} = {
    orientation = "inherit";
    modules = [prev main next];
  };
  ${main} = {
    interval = 5;
    tooltip = false;
    escape = true;
    format = "  {}";
    exec = "playerctl metadata --format='{{ artist }} - {{ title }}'";
    on-click = "playerctl play-pause";
    max-length = 50;
  };
  ${prev} = {
    interval = 5;
    tooltip = false;
    escape = true;
    format = "{icon}";
    format-icons = "󰒮";
    on-click = "playerctl previous";
    max-length = 50;
  };
  ${next} = {
    interval = 5;
    tooltip = false;
    escape = true;
    format = "{icon}";
    format-icons = "󰒭";
    on-click = "playerctl next";
    max-length = 50;
  };
}
