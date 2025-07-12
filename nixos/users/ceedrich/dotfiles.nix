{pkgs, ...}: {
  home.username = "ceedrich";
  home.homeDirectory = "/home/ceedrich";
  home.stateVersion = "24.11";

  home.packages = with pkgs; [
    signal-desktop
    vlc
    handbrake
  ];
  # Custom HM modules
  # settings = {};
  # applications = {};

  programs = {
    neovim.enable = true;
    brave.enable = true;
    ghostty.enable = true;
    spotify.enable = true;
    mangohud.enable = true;
    btop.enable = true;
    yazi.enable = true;
    # minesweeper.enable = true;
    discord.enable = true;
    tmux.enable = true;
    modrinth.enable = true;

    git = {
      enable = true;
      userName = "Cedric Lehr";
      userEmail = "info@ceedri.ch";
    };
  };
}
