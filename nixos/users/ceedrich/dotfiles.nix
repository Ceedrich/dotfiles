{pkgs, ...}: {
  imports = [
    ../minimal/dotfiles.nix
  ];
  settings = {
    hyprland.enable = true;
  };
  home.packages = with pkgs; [
    signal-desktop
    vlc
    handbrake
  ];
  # Custom HM modules
  # settings = {};
  # applications = {};

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
