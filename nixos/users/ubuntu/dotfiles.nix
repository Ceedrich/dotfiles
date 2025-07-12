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
in {
  home.username = "ceedrich";
  home.homeDirectory = "/home/ceedrich";

  nixGL.packages = nixgl.packages;

  shortcuts = {
    moodle.enable = true;
    jellyfin.enable = true;
  };

  programs = {
    neovim.enable = true;
    brave.enable = true;
    ghostty.enable = true;
    spotify.enable = true;
    btop.enable = true;
    yazi.enable = true;
    tmux.enable = true;
    # minesweeper.enable = true;
    # discord.enable = true;

    ghostty.package = nixglWrap pkgs.ghostty;
    brave.package = noSandboxWrap pkgs.brave;

    git = {
      enable = true;
      userName = "Cedric Lehr";
      userEmail = "info@ceedri.ch";
    };
  };

  rofi.enable = true;

  allowedUnfree = ["aseprite"];

  home.packages = [
    pkgs.pdfgrep
    pkgs.aseprite
    (import ../../homemanagerModules/hyprland/rofi/power-menu.nix rec {
      inherit pkgs;

      lockCommand = "i3lock -f -e -c \"#1e1e2e\"";
      logoutCommand = "/bin/loginctl kill-session self";
      shutdownCommand = "/bin/systemctl poweroff";
      rebootCommand = "/bin/systemctl reboot";
      suspendCommand = "${lockCommand} && /bin/systemctl suspend";
    })
  ];

  home.stateVersion = "24.11";
}
