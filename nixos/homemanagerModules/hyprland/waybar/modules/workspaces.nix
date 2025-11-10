{}: {
  name = "hyprland/workspaces";
  settings = {};
  style =
    #css
    ''
      #workspaces button {
        padding: 0px 4px;
        margin: 2px 4px;
        border-bottom: 2px solid;
      }

      #workspaces button.focused {
        background-color: rgba(0, 0, 0, 0.3);
        color: @rosewater;
        border-color: @rosewater;
      }

      #workspaces button.active {
        background-color: rgba(0, 0, 0, 0.3);
        color: @mauve;
        border-color: @mauve;
      }

      #workspaces button.urgent {
        background-color: @red;
      }
    '';
}
