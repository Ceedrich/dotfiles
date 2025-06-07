{ pkgs, ... }: {
  home.username = "ceedrich";
  home.homeDirectory = "/home/ceedrich";

  hyprland.enable = false;

  spotify-unfree.enable = true;

  rofi.enable = true;

  allowedUnfree = [ "aseprite" ];

  home.packages = [
    pkgs.aseprite
    (import ../homemanagerModules/hyprland/rofi/power-menu.nix {
      inherit pkgs;

      lockCommand = "i3lock -e -c \"#1e1e2e\"";
      logoutCommand = "/bin/loginctl kill-session self";
      shutdownCommand = "/bin/systemctl poweroff";
      rebootCommand = "/bin/systemctl reboot";
      suspendCommand = "/bin/systemctl suspend";
    })
  ];


  home.stateVersion = "24.11";
}
