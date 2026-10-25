{
  self,
  moduleWithSystem,
  ...
}: {
  flake.nixosModules.hypridle = moduleWithSystem ({self', ...}: {
    lib,
    config,
    ...
  }: {
    options.services.hypridle.systemdTargets = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = ["graphical-session.target"];
    };
    config.services.hypridle = {
      enable = false;
      package = self'.packages.hypridle;
    };
    config.systemd.user.services.hypridle = let
      cfg = config.services.hypridle;
    in
      lib.mkForce {
        wantedBy = cfg.systemdTargets;
        description = "hypridle";
        after = cfg.systemdTargets;
        partOf = cfg.systemdTargets;

        serviceConfig = {
          ExecStart = "${lib.getExe cfg.package}";
          Restart = "always";
          RestartSec = "10";
        };
      };
  });

  perSystem = {inputs', ...}: {
    packages.hypridle = self.wrappers.hypridle.wrap {
      pkgs = inputs'.nixpkgs-unstable.legacyPackages;
      settings = {
        general = {
          lock_cmd = "pidof hyprlock || hyprlock"; # avoid starting multiple hyprlock instances.
          before_sleep_cmd = "loginctl lock-session"; # lock before suspend.
          after_sleep_cmd = "hyprctl dispatch dpms on"; # to avoid having to press a key twice to turn on the display.
        };

        listener = [
          {
            timeout = 60 * 8;
            on-timeout = "loginctl lock-session";
          }
          {
            timeout = 60 * 10;
            on-timeout = "hyprctl dispatch dpms off";
            on-resume = "hyprctl dispatch dpms on";
          }
          {
            timeout = 60 * 30;
            on-timeout = "systemctl suspend";
          }
        ];
      };
    };
  };

  flake.wrappers.hypridle = {
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
          Configuration for hypridle.
          See <https://wiki.hypr.land/Hypr-Ecosystem/hypridle>
        '';
      };

      "hypridle.conf" = lib.mkOption {
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
          hypridle configuration file.
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
          the hypridle configuration file.
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

    config.package = lib.mkDefault pkgs.hypridle;
    config.flags."--config" = config."hypridle.conf".path;

    config.constructFiles.generatedConfig = {
      content = config."hypridle.conf".content;
      relPath = "${config.binName}.conf";
    };

    config.meta = {
      maintainers = [wlib.maintainers.nouritsu];
      platforms = lib.platforms.linux;
    };
  };
}
