{playerctl}: let
  prev = "custom/music-player-prev";
  main = "custom/music-player-main";
  next = "custom/music-player-next";
in rec {
  name = "group/music-player";
  settings = let
  in {
    ${name} = {
      orientation = "inherit";
      modules = [prev main next];
    };

    ${main} = {
      format = "{}";
      interval = 5;
      tooltip = true;
      tooltip-format = "Play/Pause";
      escape = true;
      on-click = "${playerctl}/bin/playerctl play-pause";
      on-right-click = let
        player = "${playerctl}/bin/playerctl -l | head -n1";
      in ''hyprctl dispatch focuswindow "class:(?i:^.*$(${player}).*)"'';
      max-length = 50;
      exec = "${playerctl}/bin/playerctl metadata --format='{{ artist }} - {{ title }}'";
    };
    ${prev} = {
      format = "{icon}";
      format-icons = "󰒮";
      interval = 5;
      tooltip = true;
      tooltip-format = "Previous";
      escape = true;
      max-length = 50;
      on-click = "${playerctl}/bin/playerctl previous";
      exec = "${playerctl}/bin/playerctl status";
    };
    ${next} = {
      format = "{icon}";
      format-icons = "󰒭";
      interval = 5;
      tooltip = true;
      tooltip-format = "Next";
      escape = true;
      max-length = 50;
      on-click = "${playerctl}/bin/playerctl next";
      exec = "${playerctl}/bin/playerctl status";
    };
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
