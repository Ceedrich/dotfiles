{
  # Defines the order, players should be targeted in. Only the first available player will work. If none of the specified players is available, the first other player will be used.
  playerPriorities ? ["spotify" "vlc"],
  playerctl,
  lib,
}: let
  prev = "custom/music-player-prev";
  main = "custom/music-player-main";
  next = "custom/music-player-next";
in rec {
  name = "group/music-player";
  settings = let
    players = "${lib.strings.concatStringsSep "," playerPriorities},%any";
    playercmd = "${playerctl}/bin/playerctl --player='${players}'";
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
      on-click = "${playercmd} play-pause 2>/dev/null";
      on-click-right = ''hyprctl dispatch focuswindow "class:(?i:^.*$(${playercmd} -l | head -n1).*)"'';
      max-length = 50;
      exec = "${playercmd} metadata --format='{{ artist }} - {{ title }}' 2>/dev/null";
    };
    ${prev} = {
      format = "{icon}";
      format-icons = "󰒮";
      interval = 5;
      tooltip = true;
      tooltip-format = "Previous";
      escape = true;
      max-length = 50;
      on-click = "${playercmd} previous 2>/dev/null";
      exec = "${playercmd} status 2>/dev/null";
    };
    ${next} = {
      format = "{icon}";
      format-icons = "󰒭";
      interval = 5;
      tooltip = true;
      tooltip-format = "Next";
      escape = true;
      max-length = 50;
      on-click = "${playercmd} next 2>/dev/null";
      exec = "${playercmd} status 2>/dev/null";
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
