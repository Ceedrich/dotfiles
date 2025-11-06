{
  lib,
  pavucontrol,
}: rec {
  name = "pulseaudio";
  settings = {
    ${name} = {
      format = "{volume}% {icon}";
      format-bluetooth = "{volume}% {icon}";
      format-muted = "{volume}% 󰝟";
      format-icons.default = ["󰖀" "󰕾"];
      scroll-step = 3;
      on-click = "wpctl set-mute @DEFAULT_SINK@ toggle";
      on-click-right = lib.getExe pavucontrol;
    };
  };
  style =
    #css
    ''
      #pulseaudio {
        border-bottom: 2px solid;
      }
      #pulseaudio.muted {
        color: @overlay0;
        border-color: @overlay0;
      }
    '';
}
