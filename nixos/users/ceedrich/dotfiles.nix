{pkgs, ...}: {
  imports = [
    ../minimal/dotfiles.nix
  ];
  settings = {
    hyprland.enable = true; # TODO: extract waybar out and make battery depend on what system it's running on (so, maybe remove out of home-manager into nixos config)
  };
  services.hyprpaper.enable = false;
  programs.waybar = {
    enable = false;
    enableHyprlandSupport = true;
    modules = {
      battery.enable = false;
      backlight.enable = false;
    };
  };

  home.packages = with pkgs; [
    signal-desktop
    vlc
    audacity
  ];
  # Custom HM modules
  # settings = {};
  # applications = {};

  vpn.epfl = true;
  programs = {
    brave.enable = true;
    ghostty.enable = true;
    mangohud.enable = true;
    # minesweeper.enable = true;
    discord.enable = true;
  };
}
