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
        weeks = "{}";
        weekdays = "<b>{}</b>";
        days = "<b>{}</b>";
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
