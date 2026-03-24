{
  lib,
  config,
  pkgs,
  ...
}: {
  home-manager.sharedModules = [
    {
      xdg.mimeApps.defaultApplications = config.xdg.mime.defaultApplications;
    }
  ];

  system.userActivationScripts = {
    xdg-setup = let
      handlr = "${lib.getExe pkgs.handlr-regex}";
      makeLine = mime: app: "${handlr} set ${mime} ${app}";
    in {
      text = lib.pipe config.xdg.mime.defaultApplications [
        (lib.mapAttrsToList (
          mime: apps:
            if lib.isString apps
            then [(makeLine mime apps)]
            else lib.map (makeLine mime) apps
        ))
        lib.lists.flatten
        (lib.concatStringsSep "\n")
      ];
    };
  };
}
