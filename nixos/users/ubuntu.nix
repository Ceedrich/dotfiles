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
    let
      i3lock = "i3lock -f -e -c \"#1e1e2e\"";
    in
    [
      pkgs.pdfgrep
      pkgs.aseprite
      (import ../homemanagerModules/hyprland/rofi/power-menu.nix {
        inherit pkgs;

        lockCommand = i3lock;
        logoutCommand = "/bin/loginctl kill-session self";
        shutdownCommand = "/bin/systemctl poweroff";
        rebootCommand = "/bin/systemctl reboot";
        suspendCommand = "${i3lock} && /bin/systemctl suspend";
      })
    ];


  home.stateVersion = "24.11";
}
