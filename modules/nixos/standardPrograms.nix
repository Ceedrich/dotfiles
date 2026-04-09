{...}: {
  flake.nixosModules.standardPrograms = {
    lib,
    config,
    ...
  }: let
    mkProgramModule = with lib.types;
      name:
        types.submodule ({
          config,
          lib,
          ...
        }: {
          options = {
            name = lib.mkOption {
              type = types.str;
              default = name;
              description = "Human-readable name of the program.";
            };

            package = lib.mkOption {
              type = types.nullOr types.package;
              default = null;
              description = "The package providing the ${name}.";
            };

            installPackage = lib.mkOption {
              type = types.bool;
              default = true;
              description = ''
                Whether to install the package into environment.systemPackages.
              '';
            };

            command = lib.mkOption {
              type = types.nullOr types.str;
              default = null;
              description = ''
                Command to run for ${name}. If unset and a package is provided,
                it defaults to the package's main executable.
              '';
            };
          };

          config = {
            # Derive command from package if not explicitly set
            command = lib.mkDefault (
              if config.package != null
              then lib.getExe config.package
              else null
            );
          };
        });

    mkProgramOption = name:
      lib.mkOption {
        type = mkProgramModule name;
        default = {};
      };

    standardProgramsOptions = {
      terminal = mkProgramOption "Terminal";
      browser = mkProgramOption "Browser";
      launcher = mkProgramOption "Launcher";
    };
  in {
    options.ceedrich.standardPrograms = standardProgramsOptions;

    config = let
      cfg = config.ceedrich.standardPrograms;
    in {
      environment.systemPackages = lib.pipe cfg [
        (lib.filterAttrs (program: programConfig: programConfig.package != null && programConfig.installPackage))
        (lib.mapAttrsToList (program: programConfig: programConfig.package))
      ];

      home-manager.sharedModules = [
        {
          options.ceedrich.standardPrograms = standardProgramsOptions;
          config.ceedrich.standardPrograms = cfg;
        }
      ];
    };
  };
}
