{pkgs, ...}: {
  imports = [
    ../minimal/dotfiles.nix
  ];
  settings = {
    hyprland.enable = true;
  };
  programs.waybar.modules.battery = false;

  allowedUnfree = ["aseprite"];

  home.packages = with pkgs; [
    signal-desktop
    vlc
    handbrake
    ldtk
    aseprite
    tiled
    audacity
  ];
  # Custom HM modules
  # settings = {};
  # applications = {};

  vpn.epfl = true;
  programs = {
    brave.enable = true;
    ghostty.enable = true;
    spotify.enable = true;
    mangohud.enable = true;
    # minesweeper.enable = true;
    discord.enable = true;
    modrinth.enable = true;
  };
}
