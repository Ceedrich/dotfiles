{}: rec {
  name = "clock";
  settings.${name} = {
    format = "{:%H:%M}";
    interval = 1;
    tooltip-format = "<tt><small>{calendar}</small></tt>";
    calendar = {
      mode = "month";
      weeks-pos = "left";
      on-scroll = 1;
      format = {
        months = "<b>{}</b>";
        weeks = ''<span color="#6c7086">{}</span>'';
        weekdays = "<b>{}</b>";
        days = "<b>{}</b>";
        today = ''<span color="#cba6f7"><b>{}</b></span>'';
      };
    };
  };
  style =
    #css
    ''
      #clock {
        color: @maroon;
        border-bottom: 2px solid @maroon;
        margin-right: 12px;
      }
    '';
}
