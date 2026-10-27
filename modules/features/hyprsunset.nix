{
  self,
  moduleWithSystem,
  ...
}: {
  flake.nixosModules.hyprsunset = moduleWithSystem ({self', ...}: {
    lib,
    config,
    ...
  }: {
    options.services.hyprsunset = {
      systemdTargets = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [];
      };
    };
    config.systemd.user.services.hyprsunset = let
      package = self'.packages.hyprsunset;
      cfg = config.services.hyprsunset;
    in {
      wantedBy = cfg.systemdTargets;
      description = "hyprsunset";
      after = cfg.systemdTargets;
      partOf = cfg.systemdTargets;
      serviceConfig = {
        ExecStart = "${lib.getExe package}";
        Restart = "always";
        RestartSec = "10";
      };
    };
  });

  perSystem = {
    pkgs,
    inputs',
    ...
  }: {
    packages.hyprsunset = self.wrappers.hyprsunset.wrap {
      inherit pkgs;
      package = inputs'.hyprsunset.packages.default; # Remove when commit b5c0b33e78a7a625d858edb0c7f6e3fd127579ba of hyprsunset is merged into nixpkgs.
      settings = {
        profile = [
          {
            time = "7:30";
            identity = true;
          }
          {
            time = "21:00";
            temperature = 5000;
          }
        ];
      };
    };
  };

  flake.wrappers.hyprsunset = {
    config,
    wlib,
    lib,
    pkgs,
    ...
  }: let
  in {
    imports = [wlib.modules.default];

    options = {
      settings = lib.mkOption {
        type = self.lib.hyprconfType;
        default = {};
        description = ''
          Configuration for hyprsunset.
          See <https://wiki.hypr.land/Hypr-Ecosystem/hyprsunset>
        '';
      };

      "hyprsunset.conf" = lib.mkOption {
        type = wlib.types.file {
          path = lib.mkOptionDefault config.constructFiles.generatedConfig.path;
          content = (
            lib.optionalString (config.settings != {}) (self.lib.toHyprconf {
              inherit (config) importantPrefixes;
              attrs = config.settings;
            })
            + lib.optionalString (config.extraConfig != "") config.extraConfig
          );
        };
        default = {};
        description = ''
          hyprsunset configuration file.
        '';
      };

      extraConfig = lib.mkOption {
        type = lib.types.lines;
        default = "";
        example = ''
          source = /path/to/extra.conf
        '';
        description = ''
          Extra configuration lines appended to the end of
          the hyprsunset configuration file.
        '';
      };

      importantPrefixes = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [
          "$"
          "bezier"
          "monitor"
          "size"
        ];
        example = [
          "$"
          "bezier"
        ];
        description = ''
          List of prefix strings whose matching configuration entries
          are placed at the top of the generated configuration file.
        '';
      };
    };

    config.package = lib.mkDefault pkgs.hyprsunset;
    config.flags."--config" = config."hyprsunset.conf".path;

    config.constructFiles.generatedConfig = {
      content = config."hyprsunset.conf".content;
      relPath = "${config.binName}.conf";
    };

    config.meta = {
      maintainers = [wlib.maintainers.nouritsu];
      platforms = lib.platforms.linux;
    };
  };
}
