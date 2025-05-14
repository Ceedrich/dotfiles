{ pkgs, ... }: {
  home.username = "ceedrich";
  home.homeDirectory = "/home/ceedrich";

  hyprland.enable = false;

  spotify-unfree.enable = true;

  rofi.enable = true;

  home.packages = [
    (import ../homemanagerModules/hyprland/rofi/power-menu.nix {
      inherit pkgs;

      lockCommand = "/bin/loginctl lock-session self";
      logoutCommand = "/bin/loginctl kill-session self";
      shutdownCommand = "/bin/systemctl poweroff";
      rebootCommand = "/bin/systemctl reboot";
      suspendCommand = "/bin/systemctl suspend";
    })
  ];


  home.stateVersion = "24.11";
}
