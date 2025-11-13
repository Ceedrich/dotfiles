{}: rec {
  name = "clock#date";
  settings = {
    ${name} = {
      format = "{:%d.%m.}";
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
