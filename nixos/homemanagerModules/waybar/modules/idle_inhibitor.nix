{}: rec {
  name = "idle_inhibitor";
  settings.${name} = {
    format = "{icon}";
    format-icons = {
      activated = "󰈈";
      deactivated = "󰈉";
    };
    tooltip-format-activated = "Staying Awake";
    tooltip-format-deactivated = "Sleep Enabled";
  };
  style =
    /*
    css
    */
    '''';
}
