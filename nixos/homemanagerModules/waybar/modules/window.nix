{}: rec {
  name = "hyprland/window";
  settings = {
    ${name} = {
      format = "{title}";
      format-tooltip = "Class: {class}";
      tooltip = true;
      max-length = 30;
    };
  };
  style =
    /*
    css
    */
    '''';
}
