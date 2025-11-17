{}: rec {
  name = "idle_inhibitor";
  settings.${name} = {
    format = "{icon}";
    format-icons = {
      activated = "󰈈";
      deactivated = "󰈉";
    };
    tooltip-format-activated = "Staying Awake";
    tooltip-format-deactivated = "Idling Enabled";
  };
  style =
    /*
    css
    */
    '''';
}
