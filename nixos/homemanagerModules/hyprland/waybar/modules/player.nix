{playerctl}: let
  prev = "custom/music-player-prev";
  main = "custom/music-player-main";
  next = "custom/music-player-next";
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
        cmd = "${playerctl}/bin/playerctl play-pause";
      }
      // {
        format = "  {}";
        exec = "${playerctl}/bin/playerctl metadata --format='{{ artist }} - {{ title }}'";
      };
    ${prev} =
      mkButton {
        icon = "󰒮";
        cmd = "${playerctl}/bin/playerctl previous";
      }
      // {exec = "${playerctl}/bin/playerctl status";};
    ${next} =
      mkButton {
        icon = "󰒭";
        cmd = "${playerctl}/bin/playerctl next";
      }
      // {exec = "${playerctl}/bin/playerctl status";};
  };
  style =
    #css
    ''
      #group-music-player {}
      #custom-music-player-prev {}
      #custom-music-player-main {
        padding: 8px;
      }
      #custom-music-player-next {}
    '';
}
