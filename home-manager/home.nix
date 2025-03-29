{ pkgs, lib, ... }:

{
  home.stateVersion = "24.11";

  xdg.desktopEntries = {
    moodle = {
      name = "Moodle";
      exec = "xdg-open https://moodle.epfl.ch";
      terminal = false;
      comment = "Opens Moodle in the default browser";
      icon = ./assets/EPFL.png;
    };
  };

  home.username = "ceedrich";
  home.homeDirectory = "/home/ceedrich";

  gtk.enable = true;

  home.packages = with pkgs; [
    delta
    jq
    fd
    ripgrep
    rust-with-analyzer
    pnpm
    gcc
    gnome-mines
    spotify
    gimp
    inkscape
    signal-desktop
  ];
}
