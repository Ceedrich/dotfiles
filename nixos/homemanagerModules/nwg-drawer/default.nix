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
    finalPackage = lib.mkOption {
      readOnly = true;
      internal = true;
      type = lib.types.package;
    };
  };
  config = lib.mkIf cfg.enable {
    programs.nwg-drawer.finalPackage = pkgs.writeShellApplication {
      name = "nwg-drawer";
      runtimeInputs = [pkgs.nwg-drawer];
      text = ''
        exec nwg-drawer -term ghostty -fm yazi -ovl "$@"
      '';
    };
    home.packages = [cfg.finalPackage];
    xdg.configFile."nwg-drawer/drawer.css".text = ''
      window {
          background-color: rgba(30, 30, 46, 0.8);
          color: rgb(205, 214, 244);
      }

      /* search entry */
      entry {
          background-color: rgba(17, 17, 27, 0.2);
      }

      button, image {
          background: none;
          border: none
      }

      button:hover {
          background-color: rgba(30, 30, 46, 0.1)
      }

      /* in case you wanted to give category buttons a different look */
      #category-button {
          margin: 0 10px 0 10px
      }

      #pinned-box {
          padding-bottom: 5px;
          border-bottom: 1px dotted rgb(108, 112, 134);
      }

      #files-box {
          padding: 5px;
          border: 1px dotted rgb(108, 112, 134);
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
