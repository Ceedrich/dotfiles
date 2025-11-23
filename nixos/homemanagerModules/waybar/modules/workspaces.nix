{
  lib,
  config,
  ...
}: {
  options.programs.waybar.modules.workspaces = lib.mkOption {
    default = true;
    type = lib.types.bool;
    description = "enable workspaces module";
  };

  config.programs.waybar.style =
    lib.mkIf config.programs.waybar.modules.workspaces
    #css
    ''
      #workspaces button {
        border-radius: 0;
        border: none;
        color: @overlay0;
        padding: 0px 4px;
        margin: 2px 4px;
      }

      #workspaces button.active,
      #workspaces button.focused {
        background-color: rgba(0, 0, 0, 0.3);
        color: @mauve;
        border-bottom: 2px solid;
      }

      #workspaces button.urgent {
        background-color: @red;
        border-bottom: 2px solid;
      }
    '';
}
