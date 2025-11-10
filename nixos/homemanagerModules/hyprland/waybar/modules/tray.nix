{}: rec {
  name = "tray";
  settings = {
    ${name} = {
      icon-size = 21;
      spacing = 8;
    };
  };
  style =
    #css
    ''
      #tray {
          padding: 8px;
      }
    '';
}
