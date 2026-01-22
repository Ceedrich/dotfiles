{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.programs.nwg-drawer;
in {
  options.programs.nwg-drawer = {
    enable = lib.mkEnableOption "nwg-drawer";
    package = lib.mkPackageOption pkgs "nwg-drawer" {};
  };
  config = let
    catppuccin-palette = pkgs.fetchurl {
      url = "https://cdn.jsdelivr.net/npm/@catppuccin/palette/css/catppuccin.css";
      hash = "sha256-wdDGTQ/XkfI5efbqfdBpTXgr6oX1AkjQTkVk9511IrE=";
    };
  in
    lib.mkIf cfg.enable {
      home.packages = [cfg.package];
      xdg.configFile."nwg-drawer/drawer.css".text =
        # css
        builtins.readFile catppuccin-palette
        + ''
          window {
              background-color: rgba(var(--ctp-mocha-base-rgb) / 0.95);
              color: var(--ctp-mocha-text);
          }

          /* search entry */
          entry {
              background-color: rgba(var(--ctp-mocha-crust-rgb) / 0.2);
          }

          button, image {
              background: none;
              border: none
          }

          button:hover {
              background-color: rgba(var(--ctp-mocha-text-rgb), 0.1)
          }

          /* in case you wanted to give category buttons a different look */
          #category-button {
              margin: 0 10px 0 10px
          }

          #pinned-box {
              padding-bottom: 5px;
              border-bottom: 1px dotted gray
          }

          #files-box {
              padding: 5px;
              border: 1px dotted gray;
              border-radius: 15px
          }

          /* math operation result label */
          #math-label {
              font-weight: bold;
              font-size: 16px
          }
        '';
    };
}
