{}: rec {
  name = "clock#date";
  settings = {
    ${name} = {
      format = "{:%d.%m.%Y}";
      tooltip = false;
    };
  };
  style =
    #css
    ''
      #clock.date {
          color: @overlay0;
          border: none;
        }
    '';
}
