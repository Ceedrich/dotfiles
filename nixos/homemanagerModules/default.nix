{lib, ...}: {
  imports = [
    ./hyprland
    ./git
    ./neovim
    ./shell
    ./ghostty
    ./theming
    ./spotify
    ./mangohud
    ./btop
    ./yazi
    ./tmux
    ./modrinth
    ./shortcuts
    ./minesweeper # ERROR: Broken
    ./discord
  ];

  programs.home-manager.enable = lib.mkDefault true;
}
