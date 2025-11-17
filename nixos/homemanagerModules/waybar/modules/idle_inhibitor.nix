{}: rec {
  name = "idle_inhibitor";
  settings.${name} = {
    format = "{icon}";
    format-icons = {
      activated = "󰈈";
      deactivated = "󰈉";
    };
    tooltip-format-activated = "Idling disabled";
    tooltip-format-deactivated = "Idling enabled";
  };
  style =
    /*
    css
    */
    '''';
}
