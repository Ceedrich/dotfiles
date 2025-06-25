{ pkgs, config, nixgl, ... }:
let
  nixglWrap = config.lib.nixGL.wrap;
  noSandboxWrap = pkg: pkg.overrideAttrs (old: rec {
    inherit (old) pname;
    installPhase = old.installPhase + ''
      wrapProgram $out/bin/${pname} \
        --add-flags "--no-sandbox"
    '';
  });
in
{
  home.username = "ceedrich";
  home.homeDirectory = "/home/ceedrich";

  nixGL.packages = nixgl.packages;

  hyprland.enable = false;

  spotify-unfree.enable = true;

  rofi.enable = true;

  allowedUnfree = [ "aseprite" ];

  programs.ghostty.package = nixglWrap pkgs.ghostty;
  programs.brave.package = noSandboxWrap pkgs.brave;

  home.packages =

      lockCommand = "i3lock -e -c \"#1e1e2e\"";
      logoutCommand = "/bin/loginctl kill-session self";
    [
      pkgs.pdfgrep
      pkgs.aseprite
    })
  ];
    ];


  home.stateVersion = "24.11";
}
