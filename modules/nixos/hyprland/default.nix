{inputs, ...}: {
  flake.nixosModules.hyprland = {
    config,
    lib,
    pkgs,
    ...
  }: let
    cfg = config.programs.hyprland;
  in {
    imports = [
      (inputs.import-tree ./_modules)
    ];
    options.programs.hyprland = let
      types = lib.types;
    in {
      mainMod = lib.mkOption {
        type = types.str;
        default = "SUPER";
      };
      autostart = lib.mkOption {
        type = types.listOf types.str;
        default = [];
      };
      extra-packages = lib.mkOption {
        type = types.listOf types.package;
        default = [];
      };
    };

    config = lib.mkIf cfg.enable {
      services.xserver.enable = true;
      services.xserver.excludePackages = [pkgs.xterm];

      environment.systemPackages = with pkgs;
        [
          networkmanagerapplet
          blueman
          libnotify
          hyprshutdown
        ]
        ++ cfg.extra-packages;

      programs.hyprland = {
        xwayland.enable = true;
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

      home-manager.sharedModules = [
        {
          xdg.configFile."hypr" = {
            source = ./_hypr;
            recursive = true;
          };

          services.hyprpolkitagent.enable = true;

          wayland.systemd.target = "hyprland-session.target";
          wayland.windowManager.hyprland = {
            enable = true;
            systemd.enableXdgAutostart = true;
            configType = "lua";
            extraConfig =
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

                hl.on("hyprland.start", function()
                  ${lib.pipe cfg.autostart [
                  (lib.map (prog: ''hl.exec_cmd(${prog})''))
                  (lib.concatStringsSep "\n")
                ]}
                end)
              '';
          };
        }
      ];

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
        configPackages = [pkgs.xdg-desktop-portal-hyprland];
      };

      hardware = {
        graphics.enable = true;
      };
    };
  };
}
