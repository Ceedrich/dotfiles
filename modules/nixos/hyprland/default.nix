{
  inputs,
  moduleWithSystem,
  ...
}: {
  flake.nixosModules.hyprland = moduleWithSystem ({
    inputs',
    self',
    ...
  }: {
    config,
    lib,
    pkgs,
    ...
  }: let
    cfg = config.programs.hyprland;
  in {
    config = lib.mkIf cfg.enable {
      services.xserver.enable = true;
      services.xserver.excludePackages = [pkgs.xterm];

      environment.systemPackages = with pkgs; [
        networkmanagerapplet
        blueman
        libnotify
        hyprshutdown
      ];

      programs.hyprland = {
        package = self'.packages.hyprland;
        portalPackage = inputs'.hyprland.packages.xdg-desktop-portal-hyprland;
        xwayland.enable = true;
      };

      systemd.user.targets.hyprland-session = {
        after = ["graphical-session-pre.target"];
        before = ["xdg-desktop-autostart.target"];
        bindsTo = ["graphical-session.target"];
        description = "Hyprland compositor session";
        documentation = ["man:systemd.special(7)"];
        wants = ["graphical-session-pre.target" "xdg-desktop-autostart.target"];
      };

      logoutCommands = {
        shutdown = ''hyprshutdown -t "Shutting down..." --post-cmd "systemctl poweroff"'';
        reboot = ''hyprshutdown -t "Restarting..." --post-cmd "reboot"'';
        logout = ''hyprshutdown -t "Logging out..."'';
      };

      nix.settings = {
        substituters = ["https://hyprland.cachix.org"];
        trusted-substituters = ["https://hyprland.cachix.org"];
        trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
      };

      environment.sessionVariables = {
        WLR_NO_HARDWARE_CURSORS = "1";
        NIXOS_OZONE_WL = "1";
      };

      xdg.portal = {
        enable = true;
        wlr.enable = true;
        extraPortals = [
          pkgs.xdg-desktop-portal-gtk
          pkgs.xdg-desktop-portal-wlr
          pkgs.xdg-desktop-portal-gnome
        ];
        configPackages = [inputs'.hyprland.packages.xdg-desktop-portal-hyprland];
      };

      hardware = {
        graphics.enable = true;
      };
    };
  });

  perSystem = {
    pkgs,
    lib,
    inputs',
    ...
  }: {
    packages.hyprland = inputs.wrappers.wrappers.hyprland.wrap ({config, ...}: let
      startupCommands = [
        "systemctl --user stop ${config.systemdTarget}"
        "systemctl --user start ${config.systemdTarget}"
      ];
      variables = [
        "DISPLAY"
        "HYPRLAND_INSTANCE_SIGNATURE"
        "WAYLAND_DISPLAY"
        "XDG_CURRENT_DESKTOP"
        "XDG_SESSION_TYPE"
      ];
      variables' = lib.concatStringsSep " " variables;
      startupCommands' = lib.concatStringsSep " && " startupCommands;
      hm-startup-cmd = "${pkgs.dbus}/bin/dbus-update-activation-environment --systemd ${variables'} && ${startupCommands'}";
    in {
      imports = lib.map (m: import m {inherit inputs inputs';}) (inputs.import-tree ./_modules {}).imports;
      options = {
        extraConfig = lib.mkOption {
          type = lib.types.lines;
          default = '''';
        };
        systemdTarget = lib.mkOption {
          type = lib.types.str;
          default = "hyprland-session.target";
        };
      };
      config = {
        inherit pkgs;
        package = inputs'.hyprland.packages.hyprland;
        plugins = []; # TODO: how?
        lua.dirs = [
          inputs'.catppuccin.packages.hyprland
          ./_hypr
        ];
        configFile =
          # lua
          ''
            require("animations")
            require("binds")
            require("gestures")
            require("globals")
            require("input")
            require("layerrules")
            require("misc")
            require("monitors")

            -- From home-manager
            hl.on("hyprland.start", function()
              hl.exec_cmd("${hm-startup-cmd}")
            end)
          ''
          + config.extraConfig;
      };
    });
  };
}
