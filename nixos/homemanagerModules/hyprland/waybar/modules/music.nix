{
  playerctl,
  lib,
}: let
  prev = "custom/music-player-prev";
  main = "custom/music-player-main";
  next = "custom/music-player-next";
  playerctl' = lib.getExe playerctl;
in rec {
  name = "group/music-player";
  settings = let
    mkButton = {
      icon ? "",
      cmd,
    }: {
      format = "{icon}";
      format-icons = icon;
      interval = 5;
      tooltip = false;
      escape = true;
      on-click = cmd;
      max-length = 50;
    };
  in {
    ${name} = {
      orientation = "inherit";
      modules = [prev main next];
    };

    ${main} =
      mkButton {
        cmd = "${playerctl'} play-pause";
      }
      // {
        format = "  {}";
        exec = "${playerctl} metadata --format='{{ artist }} - {{ title }}'";
      };
    ${prev} = mkButton {
      icon = "󰒮";
      cmd = "${playerctl'} previous";
    };
    ${next} = mkButton {
      icon = "";
      cmd = "${playerctl'} next";
    };
  };
  style =
    #css
    ''
      #group-music-player {}
      #custom-music-player-prev {}
      #custom-music-player-main {}
      #custom-music-player-next {}
    '';
}
