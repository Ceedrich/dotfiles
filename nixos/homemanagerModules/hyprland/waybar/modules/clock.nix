{}: rec {
  name = "clock";
  settings.${name} = {
    format = "{:%H:%M}  ";
    interval = 1;
    tooltip-format = "{%A %B %d %Y (%R)}<br><tt><small>{calendar}</small></tt>";
    calendar = {
      mode = "month";
      weeks-pos = "left";
      on-scroll = 1;
      format = {
        months = "<b>{}</b>";
        days = "<b>{}</b>";
        weeks = "<b>{}</b>";
        weekdays = "<b>{}</b>";
        today = "<b><u>{}</u></b>";
      };
    };
    actions = {
      on-click = "shift_reset";
      on-scroll-up = "shift_up";
      on-scroll-down = "shift_down";
    };
  };
  style =
    #css
    '''';
}
