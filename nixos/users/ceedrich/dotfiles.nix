{pkgs, ...}: {
  imports = [
    ../minimal/dotfiles.nix
  ];
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
