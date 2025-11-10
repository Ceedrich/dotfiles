{}: {
  name = "hyprland/workspaces";
  settings = {};
  style =
    #css
    ''
      #workspaces button {
        color: @overlay0;
        padding: 0px 4px;
        margin: 2px 4px;
      }

      #workspaces button.active {
        background-color: rgba(0, 0, 0, 0.3);
        color: @mauve;
        border-color: @mauve;
        border-bottom: 2px solid;
      }

      #workspaces button.urgent {
        background-color: @red;
        border-bottom: 2px solid;
      }
    '';
}
