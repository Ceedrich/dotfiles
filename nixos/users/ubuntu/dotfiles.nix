{
  pkgs,
  config,
  nixgl,
  ...
}: let
  nixglWrap = config.lib.nixGL.wrap;
  noSandboxWrap = pkg:
    pkg.overrideAttrs (old: rec {
      inherit (old) pname;
      installPhase =
        old.installPhase
        + ''
          wrapProgram $out/bin/${pname} \
            --add-flags "--no-sandbox"
        '';
    });

  lockCommand = "swaylock -f -e -c '#1e1e2e'";
  logoutCommand = "/bin/loginctl kill-session self";
  shutdownCommand = "/bin/systemctl poweroff";
  rebootCommand = "/bin/systemctl reboot";
  suspendCommand = "${lockCommand} && /bin/systemctl suspend";
in {
  imports = [
    ../minimal/dotfiles.nix
  ];
  targets.genericLinux.nixGL.packages = nixgl.packages;

  shortcuts = {
    moodle.enable = true;
    jellyfin.enable = true;
  };

  programs = {
    brave.enable = true;
    ghostty.enable = true;
    waybar = {
      enable = true;
      enableSwaySupport = true;
      modules.powermenu = {
        inherit
          lockCommand
          shutdownCommand
          rebootCommand
          suspendCommand
          logoutCommand
          ;
      };
    };
    # minesweeper.enable = true;
    # discord.enable = true;

    ghostty.package = nixglWrap pkgs.ghostty;
    brave.package = noSandboxWrap pkgs.brave;
  };

  programs.rofi.enable = true;

  allowedUnfree = ["aseprite"];

  home.packages = [
    pkgs.texliveFull
    pkgs.pdfgrep
    pkgs.aseprite
    (pkgs.callPackage ../../homemanagerModules/hyprland/rofi/power-menu.nix rec {
      inherit
        lockCommand
        shutdownCommand
        rebootCommand
        suspendCommand
        logoutCommand
        ;
    })
    (pkgs.callPackage ../../packages/space.nix {})
    (pkgs.callPackage ../../packages/passmenu {})
  ];
}
